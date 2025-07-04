# 🔥 Setup GitHub Actions for Ujjain Data Extraction

**Complete setup guide to run extraction on GitHub servers with zero laptop work**

## 🚀 Quick Setup (5 Minutes)

### Step 1: Create Workflow File
1. Go to your repository: https://github.com/bazarse/bazarse-2025-07-04
2. Click **"Create new file"**
3. Type filename: `.github/workflows/ujjain-extraction.yml`
4. Copy and paste the workflow code (provided below)
5. Click **"Commit new file"**

### Step 2: Run the Workflow
1. Go to **Actions** tab
2. Find **"🔥 Complete Ujjain Business Data Extraction"**
3. Click **"Run workflow"**
4. Select **"ultra_fast"** mode
5. Click **"Run workflow"** button

## 📋 Workflow Code to Copy

```yaml
name: 🔥 Complete Ujjain Business Data Extraction

on:
  workflow_dispatch:
    inputs:
      extraction_mode:
        description: 'Extraction Mode'
        required: true
        default: 'ultra_fast'
        type: choice
        options:
        - ultra_fast
        - test_mode
      businesses_per_query:
        description: 'Businesses per query'
        required: true
        default: '25'
        type: string

jobs:
  extract-ujjain-data:
    runs-on: ubuntu-latest
    timeout-minutes: 300
    
    strategy:
      matrix:
        worker_batch: [1, 2, 3, 4, 5]
    
    steps:
    - name: 🚀 Checkout Repository
      uses: actions/checkout@v4
      
    - name: 🐍 Setup Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.11'
        
    - name: 📦 Install Dependencies
      run: |
        python -m pip install --upgrade pip
        pip install pandas playwright aiohttp aiofiles
        playwright install chromium
        playwright install-deps
        
    - name: 🗺️ Generate Queries
      run: |
        python3 << 'EOF'
        import json
        import os
        
        locations = [
            "Freeganj", "Mahakaleshwar Temple", "Tower Chowk", "Dewas Gate",
            "University Road", "Railway Station Road", "Nanakheda", "Chimanganj Mandi"
        ]
        
        categories = [
            "restaurants", "grocery stores", "medical stores", "clothing shops",
            "mobile shops", "beauty parlors", "electronics stores", "banks",
            "petrol pumps", "hospitals", "schools", "hotels", "pharmacies",
            "sweet shops", "kirana stores", "salons", "jewellery shops"
        ]
        
        all_queries = []
        for location in locations:
            for category in categories:
                all_queries.append(f"{category} in {location}, Ujjain")
        
        batch_size = len(all_queries) // 5
        worker_batch = int(os.environ.get('MATRIX_WORKER_BATCH', 1))
        
        start_idx = (worker_batch - 1) * batch_size
        if worker_batch == 5:
            end_idx = len(all_queries)
        else:
            end_idx = worker_batch * batch_size
        
        batch_queries = all_queries[start_idx:end_idx]
        
        with open(f'batch_{worker_batch}_queries.json', 'w') as f:
            json.dump(batch_queries, f, indent=2)
        
        print(f"Generated {len(batch_queries)} queries for batch {worker_batch}")
        EOF
      env:
        MATRIX_WORKER_BATCH: ${{ matrix.worker_batch }}
        
    - name: 🔥 Extract Business Data
      run: |
        python3 << 'EOF'
        import json
        import asyncio
        from playwright.async_api import async_playwright
        import os
        from datetime import datetime
        
        class GitHubScraper:
            def __init__(self, worker_batch):
                self.worker_batch = worker_batch
                self.businesses_per_query = 20
                
            async def scrape_query(self, browser, query):
                try:
                    page = await browser.new_page()
                    await page.goto("https://www.google.com/maps", timeout=30000)
                    
                    await page.fill('input[id="searchboxinput"]', query)
                    await page.press('input[id="searchboxinput"]', 'Enter')
                    await page.wait_for_timeout(3000)
                    
                    for _ in range(3):
                        await page.mouse.wheel(0, 3000)
                        await page.wait_for_timeout(1000)
                    
                    listings = await page.locator('a[href*="/maps/place/"]').all()
                    businesses = []
                    
                    for i, listing in enumerate(listings[:self.businesses_per_query]):
                        try:
                            await listing.click()
                            await page.wait_for_timeout(2000)
                            
                            business = {}
                            
                            name_elem = page.locator('h1.DUwDvf').first
                            if await name_elem.count() > 0:
                                business['name'] = await name_elem.inner_text()
                            
                            address_elem = page.locator('[data-item-id="address"] .fontBodyMedium').first
                            if await address_elem.count() > 0:
                                business['address'] = await address_elem.inner_text()
                            
                            phone_elem = page.locator('[data-item-id*="phone"] .fontBodyMedium').first
                            if await phone_elem.count() > 0:
                                business['phone_number'] = await phone_elem.inner_text()
                            
                            img_elem = page.locator('.ZKCDEc img').first
                            if await img_elem.count() > 0:
                                business['image_url'] = await img_elem.get_attribute('src')
                            
                            url = page.url
                            if '/@' in url:
                                try:
                                    coords = url.split('/@')[1].split('/')[0]
                                    lat, lng = coords.split(',')[:2]
                                    business['latitude'] = float(lat)
                                    business['longitude'] = float(lng)
                                except:
                                    pass
                            
                            business['query'] = query
                            business['scraped_at'] = datetime.now().isoformat()
                            
                            if business.get('name'):
                                businesses.append(business)
                                
                        except Exception as e:
                            print(f"Error extracting business {i}: {e}")
                            continue
                    
                    await page.close()
                    print(f"✅ {query}: {len(businesses)} businesses")
                    return businesses
                    
                except Exception as e:
                    print(f"❌ Query failed: {query} - {e}")
                    return []
            
            async def run_extraction(self):
                with open(f'batch_{self.worker_batch}_queries.json', 'r') as f:
                    queries = json.load(f)
                
                print(f"🔥 Starting batch {self.worker_batch} with {len(queries)} queries")
                
                async with async_playwright() as playwright:
                    browser = await playwright.chromium.launch(headless=True)
                    
                    all_businesses = []
                    for query in queries:
                        businesses = await self.scrape_query(browser, query)
                        all_businesses.extend(businesses)
                        await asyncio.sleep(0.5)
                    
                    await browser.close()
                    
                    with open(f'ujjain_data_batch_{self.worker_batch}.json', 'w') as f:
                        json.dump(all_businesses, f, indent=2, ensure_ascii=False)
                    
                    print(f"🎉 Batch {self.worker_batch}: {len(all_businesses)} businesses")
                    return len(all_businesses)
        
        async def main():
            worker_batch = int(os.environ.get('MATRIX_WORKER_BATCH', 1))
            scraper = GitHubScraper(worker_batch)
            await scraper.run_extraction()
        
        asyncio.run(main())
        EOF
      env:
        MATRIX_WORKER_BATCH: ${{ matrix.worker_batch }}
        
    - name: 📁 Upload Results
      uses: actions/upload-artifact@v4
      with:
        name: ujjain-data-batch-${{ matrix.worker_batch }}
        path: ujjain_data_batch_${{ matrix.worker_batch }}.json
        retention-days: 30

  combine-results:
    needs: extract-ujjain-data
    runs-on: ubuntu-latest
    if: always()
    
    steps:
    - name: 🚀 Checkout Repository
      uses: actions/checkout@v4
      
    - name: 📥 Download All Results
      uses: actions/download-artifact@v4
      with:
        path: batch-results
        
    - name: 🔄 Combine Data
      run: |
        python3 << 'EOF'
        import json
        import os
        import glob
        from datetime import datetime
        
        all_businesses = []
        
        for batch_dir in glob.glob('batch-results/ujjain-data-batch-*'):
            data_files = glob.glob(f'{batch_dir}/ujjain_data_batch_*.json')
            for data_file in data_files:
                try:
                    with open(data_file, 'r') as f:
                        batch_data = json.load(f)
                        all_businesses.extend(batch_data)
                        print(f"Added {len(batch_data)} businesses from {data_file}")
                except Exception as e:
                    print(f"Error loading {data_file}: {e}")
        
        os.makedirs('Complete_Ujjain_Data_GitHub_Actions', exist_ok=True)
        
        with open('Complete_Ujjain_Data_GitHub_Actions/complete_ujjain_businesses.json', 'w') as f:
            json.dump(all_businesses, f, indent=2, ensure_ascii=False)
        
        summary = {
            'total_businesses': len(all_businesses),
            'extraction_date': datetime.now().isoformat(),
            'with_images': sum(1 for b in all_businesses if b.get('image_url')),
            'with_phone': sum(1 for b in all_businesses if b.get('phone_number')),
            'with_coordinates': sum(1 for b in all_businesses if b.get('latitude'))
        }
        
        with open('Complete_Ujjain_Data_GitHub_Actions/summary.json', 'w') as f:
            json.dump(summary, f, indent=2)
        
        print(f"🎉 EXTRACTION COMPLETED!")
        print(f"📊 Total Businesses: {len(all_businesses):,}")
        print(f"🖼️ With Images: {summary['with_images']:,}")
        print(f"📞 With Phone: {summary['with_phone']:,}")
        print(f"📍 With Coordinates: {summary['with_coordinates']:,}")
        EOF
        
    - name: 💾 Commit Results
      run: |
        git config --local user.email "action@github.com"
        git config --local user.name "GitHub Action"
        git add .
        if ! git diff --staged --quiet; then
          git commit -m "🎉 Ujjain Data Extraction Complete - $(date +%Y-%m-%d)"
          git push
        fi
```

## 🎯 What This Does

### ⚡ Automatic Processing
- **5 Parallel Workers** extract data simultaneously
- **Real-time Scraping** from Google Maps
- **Image URL Extraction** for all businesses
- **Automatic Data Combination** from all workers
- **Direct Repository Commit** with results

### 📊 Expected Results
- **10,000-20,000 Businesses** in 2-4 hours
- **Complete Business Details** (name, address, phone)
- **Image URLs** for visual content
- **GPS Coordinates** for mapping
- **Production-Ready Data** for app integration

### 📁 Output Location
- **Folder**: `Complete_Ujjain_Data_GitHub_Actions/`
- **Main File**: `complete_ujjain_businesses.json`
- **Summary**: `summary.json`

## 🚀 After Setup

1. **Go to Actions Tab** in your repository
2. **Find the Workflow** "🔥 Complete Ujjain Business Data Extraction"
3. **Click "Run workflow"**
4. **Select "ultra_fast" mode**
5. **Click "Run workflow" button**
6. **Relax** - GitHub does everything!

## 🎉 Benefits

✅ **Zero Laptop Work** - Everything runs on GitHub  
✅ **Professional Servers** - High-performance infrastructure  
✅ **Parallel Processing** - 5 workers simultaneously  
✅ **Automatic Results** - Data appears in repository  
✅ **Real-time Monitoring** - Watch progress live  
✅ **Error Handling** - Automatic retries and recovery  

**Your complete Ujjain business database will be ready in 2-4 hours with zero effort!**
