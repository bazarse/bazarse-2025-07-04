#!/usr/bin/env python3
"""
🔥 AUTOMATIC UJJAIN SCRAPER - RUNNING NOW 🔥
Complete automation - no user input needed
"""

import asyncio
import json
import os
import time
from datetime import datetime
from playwright.async_api import async_playwright
import subprocess
import sys

class AutoUjjainScraper:
    def __init__(self):
        self.total_businesses = 0
        self.results_dir = f"Auto_Ujjain_Results_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        os.makedirs(self.results_dir, exist_ok=True)
        
    def get_priority_queries(self):
        """Get high-priority queries for quick results"""
        
        locations = [
            "Freeganj, Ujjain",
            "Mahakaleshwar Temple, Ujjain", 
            "Tower Chowk, Ujjain",
            "Dewas Gate, Ujjain",
            "University Road, Ujjain"
        ]
        
        categories = [
            "restaurants", "grocery stores", "medical stores", 
            "clothing shops", "mobile shops", "beauty parlors",
            "electronics stores", "banks", "petrol pumps",
            "hospitals", "schools", "hotels", "pharmacies",
            "sweet shops", "kirana stores", "salons"
        ]
        
        queries = []
        for location in locations:
            for category in categories:
                queries.append(f"{category} in {location}")
        
        return queries
    
    async def extract_business_data(self, page, query):
        """Extract business data quickly"""
        
        try:
            business = {}
            
            # Name
            name_elem = page.locator('h1.DUwDvf').first
            if await name_elem.count() > 0:
                business['name'] = await name_elem.inner_text()
            
            # Address  
            address_elem = page.locator('[data-item-id="address"] .fontBodyMedium').first
            if await address_elem.count() > 0:
                business['address'] = await address_elem.inner_text()
            
            # Phone
            phone_elem = page.locator('[data-item-id*="phone"] .fontBodyMedium').first
            if await phone_elem.count() > 0:
                business['phone_number'] = await phone_elem.inner_text()
            
            # Image URL
            img_elem = page.locator('.ZKCDEc img').first
            if await img_elem.count() > 0:
                business['image_url'] = await img_elem.get_attribute('src')
            
            # Rating
            rating_elem = page.locator('[role="img"][aria-label*="stars"]').first
            if await rating_elem.count() > 0:
                rating_text = await rating_elem.get_attribute('aria-label')
                if rating_text:
                    try:
                        business['rating'] = float(rating_text.split()[0])
                    except:
                        pass
            
            # Coordinates from URL
            url = page.url
            if '/@' in url:
                try:
                    coords = url.split('/@')[1].split('/')[0]
                    lat, lng = coords.split(',')[:2]
                    business['latitude'] = float(lat)
                    business['longitude'] = float(lng)
                except:
                    pass
            
            # Category
            business['category'] = self.categorize_business(query)
            business['query'] = query
            business['scraped_at'] = datetime.now().isoformat()
            
            return business if business.get('name') else None
            
        except Exception as e:
            print(f"Error extracting data: {e}")
            return None
    
    def categorize_business(self, query):
        """Quick categorization"""
        
        query_lower = query.lower()
        
        if any(word in query_lower for word in ['restaurant', 'food', 'sweet']):
            return 'Food & Dining'
        elif any(word in query_lower for word in ['grocery', 'kirana']):
            return 'Grocery & Daily'
        elif any(word in query_lower for word in ['medical', 'hospital', 'pharmacy']):
            return 'Health & Medical'
        elif any(word in query_lower for word in ['clothing', 'fashion']):
            return 'Fashion & Retail'
        elif any(word in query_lower for word in ['mobile', 'electronics']):
            return 'Electronics & Tech'
        elif any(word in query_lower for word in ['beauty', 'salon']):
            return 'Beauty & Care'
        else:
            return 'General Business'
    
    async def scrape_query(self, browser, query):
        """Scrape a single query"""
        
        try:
            page = await browser.new_page()
            await page.goto("https://www.google.com/maps", timeout=30000)
            
            # Search
            await page.fill('input[id="searchboxinput"]', query)
            await page.press('input[id="searchboxinput"]', 'Enter')
            await page.wait_for_timeout(3000)
            
            # Scroll to load results
            for _ in range(3):
                await page.mouse.wheel(0, 3000)
                await page.wait_for_timeout(1000)
            
            # Get listings
            listings = await page.locator('a[href*="/maps/place/"]').all()
            businesses = []
            
            for i, listing in enumerate(listings[:15]):  # Limit to 15 per query
                try:
                    await listing.click()
                    await page.wait_for_timeout(2000)
                    
                    business = await self.extract_business_data(page, query)
                    if business:
                        businesses.append(business)
                        
                except Exception as e:
                    print(f"Error extracting business {i}: {e}")
                    continue
            
            await page.close()
            
            # Save immediately
            safe_query = query.replace(' ', '_').replace(',', '').replace('/', '_')
            filename = f"{safe_query}_{datetime.now().strftime('%H%M%S')}.json"
            filepath = os.path.join(self.results_dir, filename)
            
            with open(filepath, 'w') as f:
                json.dump(businesses, f, indent=2, ensure_ascii=False)
            
            self.total_businesses += len(businesses)
            print(f"✅ {query}: {len(businesses)} businesses (Total: {self.total_businesses})")
            
            return businesses
            
        except Exception as e:
            print(f"❌ Query failed: {query} - {e}")
            return []
    
    async def run_extraction(self):
        """Run the complete extraction"""
        
        print("🔥 AUTOMATIC UJJAIN SCRAPER STARTING 🔥")
        print("=" * 60)
        
        queries = self.get_priority_queries()
        print(f"📊 Processing {len(queries)} priority queries")
        print(f"🎯 Expected: {len(queries) * 15} businesses")
        print(f"📁 Results saving to: {self.results_dir}")
        
        start_time = time.time()
        
        async with async_playwright() as playwright:
            browser = await playwright.chromium.launch(headless=True)
            
            all_businesses = []
            
            for i, query in enumerate(queries):
                print(f"\n🔄 Processing {i+1}/{len(queries)}: {query}")
                
                businesses = await self.scrape_query(browser, query)
                all_businesses.extend(businesses)
                
                # Small delay
                await asyncio.sleep(0.5)
                
                # Progress update every 10 queries
                if (i + 1) % 10 == 0:
                    elapsed = (time.time() - start_time) / 60
                    print(f"📊 Progress: {i+1}/{len(queries)} queries, {len(all_businesses)} businesses, {elapsed:.1f} minutes")
            
            await browser.close()
            
            # Save combined results
            combined_file = os.path.join(self.results_dir, 'complete_ujjain_businesses.json')
            with open(combined_file, 'w') as f:
                json.dump(all_businesses, f, indent=2, ensure_ascii=False)
            
            # Generate summary
            summary = {
                'total_businesses': len(all_businesses),
                'total_queries': len(queries),
                'extraction_date': datetime.now().isoformat(),
                'categories': {},
                'with_images': sum(1 for b in all_businesses if b.get('image_url')),
                'with_phone': sum(1 for b in all_businesses if b.get('phone_number')),
                'with_coordinates': sum(1 for b in all_businesses if b.get('latitude')),
                'with_rating': sum(1 for b in all_businesses if b.get('rating'))
            }
            
            # Count categories
            for business in all_businesses:
                category = business.get('category', 'Unknown')
                summary['categories'][category] = summary['categories'].get(category, 0) + 1
            
            summary_file = os.path.join(self.results_dir, 'extraction_summary.json')
            with open(summary_file, 'w') as f:
                json.dump(summary, f, indent=2)
            
            end_time = time.time()
            duration = (end_time - start_time) / 60
            
            print(f"\n🎉 EXTRACTION COMPLETED!")
            print(f"⏱️  Duration: {duration:.1f} minutes")
            print(f"📊 Total Businesses: {len(all_businesses)}")
            print(f"🖼️  With Images: {summary['with_images']}")
            print(f"📞 With Phone: {summary['with_phone']}")
            print(f"📍 With Coordinates: {summary['with_coordinates']}")
            print(f"⭐ With Ratings: {summary['with_rating']}")
            print(f"📁 Results saved in: {self.results_dir}")
            
            return len(all_businesses)

async def main():
    """Main function - runs automatically"""
    
    print("🔥 STARTING AUTOMATIC UJJAIN DATA EXTRACTION 🔥")
    print("🚀 NO USER INPUT REQUIRED - RUNNING AUTOMATICALLY")
    print("=" * 60)
    
    scraper = AutoUjjainScraper()
    total_businesses = await scraper.run_extraction()
    
    print(f"\n🎉 AUTOMATIC EXTRACTION COMPLETED!")
    print(f"📊 Total businesses extracted: {total_businesses}")
    print(f"📁 Check results in: {scraper.results_dir}")
    
    return scraper.results_dir

if __name__ == "__main__":
    asyncio.run(main())
