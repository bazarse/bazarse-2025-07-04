#!/usr/bin/env python3
"""
🔥 BAZAR SE SCRAPER TEST - QUICK SAMPLE TEST 🔥
Test the enhanced scraper with a small sample
"""

import subprocess
import sys
import os
import pandas as pd
from datetime import datetime

def run_test_scraping():
    """Run a quick test with limited data"""
    print("🔥 BAZAR SE SCRAPER TEST 🔥")
    print("=" * 50)
    
    # Test queries - small sample
    test_queries = [
        "restaurants in Freeganj, Ujjain",
        "medical stores in Tower Chowk, Ujjain", 
        "mobile shops in Dewas Gate, Ujjain",
        "beauty parlors in Mahakaleshwar Temple, Ujjain",
        "grocery stores in University Road, Ujjain"
    ]
    
    print(f"🎯 Testing with {len(test_queries)} sample queries")
    print("📊 Expected: 5-10 businesses per query")
    print("⏱️ Estimated time: 10-15 minutes")
    print()
    
    # Create test input file
    with open('test_queries.txt', 'w') as f:
        for query in test_queries:
            f.write(query + '\n')
    
    print("✅ Created test queries file")
    
    # Run the scraper with limited results
    print("🚀 Starting test scraping...")
    try:
        cmd = [
            sys.executable, 
            'google_maps_scraper_bazarse.py',
            '-t', '10',  # Limit to 10 results per query
            '--test'     # Test mode flag
        ]
        
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=1200)  # 20 min timeout
        
        if result.returncode == 0:
            print("✅ Test scraping completed successfully!")
            print(result.stdout)
        else:
            print("❌ Test scraping failed!")
            print("Error:", result.stderr)
            return False
            
    except subprocess.TimeoutExpired:
        print("⏰ Test scraping timed out (20 minutes)")
        return False
    except Exception as e:
        print(f"❌ Error running test: {e}")
        return False
    
    # Analyze results
    analyze_test_results()
    return True

def analyze_test_results():
    """Analyze the test results"""
    print("\n📊 ANALYZING TEST RESULTS")
    print("=" * 40)
    
    # Look for generated files
    today = datetime.now().strftime("%Y-%m-%d")
    data_dir = f"Ujjain_Business_Data/{today}"
    
    if not os.path.exists(data_dir):
        print("❌ No data directory found")
        return
    
    csv_files = [f for f in os.listdir(data_dir) if f.endswith('.csv')]
    
    if not csv_files:
        print("❌ No CSV files found")
        return
    
    print(f"✅ Found {len(csv_files)} data files")
    
    total_businesses = 0
    categories_found = set()
    
    for csv_file in csv_files:
        try:
            df = pd.read_csv(os.path.join(data_dir, csv_file))
            count = len(df)
            total_businesses += count
            
            print(f"📁 {csv_file}: {count} businesses")
            
            # Show sample data
            if count > 0:
                print("   Sample business:")
                sample = df.iloc[0]
                print(f"   📍 Name: {sample.get('name', 'N/A')}")
                print(f"   📍 Address: {sample.get('address', 'N/A')}")
                print(f"   📍 Phone: {sample.get('phone_number', 'N/A')}")
                print(f"   📍 Category: {sample.get('primary_category', 'N/A')}")
                print(f"   📍 Subcategory: {sample.get('primary_subcategory', 'N/A')}")
                print(f"   📍 Rating: {sample.get('reviews_average', 'N/A')}")
                print(f"   📍 Image: {sample.get('image_url', 'N/A')[:50]}...")
                print()
                
                if 'primary_category' in df.columns:
                    categories_found.update(df['primary_category'].dropna().unique())
        
        except Exception as e:
            print(f"❌ Error reading {csv_file}: {e}")
    
    print(f"🎉 TOTAL BUSINESSES EXTRACTED: {total_businesses}")
    print(f"📂 CATEGORIES FOUND: {len(categories_found)}")
    
    if categories_found:
        print("📋 Categories:")
        for category in sorted(categories_found):
            print(f"   ✅ {category}")
    
    print(f"\n📁 Data saved in: {data_dir}")

def show_sample_data_structure():
    """Show expected data structure"""
    print("\n📋 EXPECTED DATA STRUCTURE")
    print("=" * 40)
    
    sample_business = {
        "name": "Mahakal Sweets & Restaurant",
        "address": "Near Mahakaleshwar Temple, Ujjain, MP 456001",
        "phone_number": "+91 9876543210",
        "website": "https://www.mahakalsweets.com",
        "primary_category": "🍽️ FOOD & DINING",
        "primary_subcategory": "Restaurants",
        "categories": ["🍽️ FOOD & DINING"],
        "subcategories": ["Restaurants", "Sweet Shops"],
        "area": "Mahakaleshwar Temple",
        "city": "Ujjain",
        "state": "Madhya Pradesh",
        "reviews_average": 4.5,
        "reviews_count": 150,
        "latitude": 23.1765,
        "longitude": 75.7885,
        "image_url": "https://lh3.googleusercontent.com/...",
        "opening_hours": "6:00 AM - 11:00 PM",
        "verified": True,
        "source": "google_maps_scraper"
    }
    
    print("📊 Sample Business Data:")
    for key, value in sample_business.items():
        print(f"   {key}: {value}")

def main():
    """Main test function"""
    print("🔥 BAZAR SE GOOGLE MAPS SCRAPER - TEST MODE 🔥")
    print("=" * 60)
    
    # Show what we're testing
    show_sample_data_structure()
    
    print("\n🎯 TEST PLAN:")
    print("1. Test 5 different categories")
    print("2. Test 5 different Ujjain locations") 
    print("3. Extract 10 businesses per category")
    print("4. Verify data quality and structure")
    print("5. Check image URL extraction")
    print("6. Validate multiple categories per business")
    
    choice = input("\n👉 Start test scraping? (y/n): ").lower()
    
    if choice == 'y':
        if run_test_scraping():
            print("\n🎉 TEST COMPLETED SUCCESSFULLY!")
            print("\n📋 Next Steps:")
            print("1. Review the extracted data")
            print("2. Run full scraping with --ujjain flag")
            print("3. Upload to Firebase with --firebase flag")
        else:
            print("\n❌ TEST FAILED!")
            print("Please check the error messages above")
    else:
        print("👋 Test cancelled")

if __name__ == "__main__":
    main()
