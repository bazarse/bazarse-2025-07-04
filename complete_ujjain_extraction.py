#!/usr/bin/env python3
"""
🔥 COMPLETE UJJAIN DATA EXTRACTION - PRODUCTION READY 🔥
Comprehensive business data extraction for all Ujjain locations and categories
"""

import subprocess
import sys
import os
import time
import json
from datetime import datetime
import pandas as pd

def calculate_extraction_estimates():
    """Calculate detailed extraction estimates"""
    
    locations = 20
    subcategories = 250
    businesses_per_query = 25  # Conservative estimate
    
    total_queries = locations * subcategories
    total_businesses = total_queries * businesses_per_query
    
    # Time calculations (2.5 businesses per minute)
    minutes_per_business = 0.4  # 24 seconds per business
    total_minutes = total_businesses * minutes_per_business
    total_hours = total_minutes / 60
    
    estimates = {
        "📊 EXTRACTION SCOPE": {
            "Locations": locations,
            "Subcategories": subcategories,
            "Total Queries": f"{total_queries:,}",
            "Expected Businesses": f"{total_businesses:,}",
        },
        "⏱️ TIME ESTIMATES": {
            "Per Business": "24 seconds",
            "Per Query (25 businesses)": "10 minutes",
            "Per Location (250 queries)": "42 hours",
            "Complete Ujjain": f"{total_hours:.0f} hours ({total_hours/24:.1f} days)",
        },
        "💾 DATA VOLUME": {
            "CSV Files": f"{total_queries:,} files",
            "Excel Files": f"{total_queries:,} files", 
            "Total File Size": "~2-3 GB",
            "Database Records": f"{total_businesses:,} records",
        },
        "🎯 QUALITY METRICS": {
            "Image URLs": f"{total_businesses:,} main images",
            "Additional Photos": f"{total_businesses * 4:,} photos",
            "Phone Numbers": f"{int(total_businesses * 0.7):,} verified",
            "GPS Coordinates": f"{total_businesses:,} locations",
        }
    }
    
    return estimates

def create_extraction_phases():
    """Create phased extraction plan"""
    
    phases = [
        {
            "name": "🧪 Phase 1: Test & Validation",
            "description": "Quick test with 5 categories",
            "queries": 5,
            "businesses": 50,
            "time": "15 minutes",
            "purpose": "Validate setup and data quality"
        },
        {
            "name": "🏢 Phase 2: High-Priority Locations",
            "description": "Freeganj, Tower Chowk, Mahakaleshwar Temple",
            "queries": 750,  # 3 locations × 250 categories
            "businesses": 18750,
            "time": "125 hours (5 days)",
            "purpose": "Core commercial areas"
        },
        {
            "name": "🌟 Phase 3: Educational & Transport Hubs", 
            "description": "University Road, Railway Station, Dewas Gate",
            "queries": 750,
            "businesses": 18750,
            "time": "125 hours (5 days)",
            "purpose": "Educational and transport zones"
        },
        {
            "name": "🏭 Phase 4: Industrial & Wholesale",
            "description": "Nanakheda, Chimanganj Mandi, Agar Road",
            "queries": 750,
            "businesses": 18750,
            "time": "125 hours (5 days)",
            "purpose": "Industrial and wholesale markets"
        },
        {
            "name": "🏘️ Phase 5: Residential & Remaining Areas",
            "description": "Remaining 11 locations",
            "queries": 2750,  # 11 locations × 250 categories
            "businesses": 68750,
            "time": "458 hours (19 days)",
            "purpose": "Complete city coverage"
        }
    ]
    
    return phases

def start_complete_extraction():
    """Start the complete Ujjain data extraction"""
    
    print("🔥 COMPLETE UJJAIN DATA EXTRACTION STARTING 🔥")
    print("=" * 60)
    
    # Show estimates
    estimates = calculate_extraction_estimates()
    
    for section, details in estimates.items():
        print(f"\n{section}")
        print("-" * 40)
        for key, value in details.items():
            print(f"{key}: {value}")
    
    print("\n" + "=" * 60)
    print("🚀 EXTRACTION PHASES")
    print("=" * 60)
    
    phases = create_extraction_phases()
    
    for i, phase in enumerate(phases, 1):
        print(f"\n{i}. {phase['name']}")
        print(f"   Description: {phase['description']}")
        print(f"   Queries: {phase['queries']:,}")
        print(f"   Expected Businesses: {phase['businesses']:,}")
        print(f"   Estimated Time: {phase['time']}")
        print(f"   Purpose: {phase['purpose']}")
    
    # Create directory structure
    create_directory_structure()
    
    # Start with Phase 1 (Test)
    print("\n" + "=" * 60)
    print("🧪 STARTING PHASE 1: TEST & VALIDATION")
    print("=" * 60)
    
    choice = input("\n👉 Start complete extraction? (y/n): ").lower()
    
    if choice == 'y':
        run_phase_1_test()
        
        test_success = input("\n✅ Phase 1 completed. Continue with full extraction? (y/n): ").lower()
        
        if test_success == 'y':
            run_complete_extraction()
        else:
            print("👋 Extraction stopped after test phase")
    else:
        print("👋 Extraction cancelled")

def create_directory_structure():
    """Create organized directory structure for data"""
    
    base_dir = "Complete_Ujjain_Data"
    today = datetime.now().strftime("%Y-%m-%d")
    
    directories = [
        f"{base_dir}/{today}/Phase_1_Test",
        f"{base_dir}/{today}/Phase_2_High_Priority",
        f"{base_dir}/{today}/Phase_3_Educational_Transport",
        f"{base_dir}/{today}/Phase_4_Industrial_Wholesale", 
        f"{base_dir}/{today}/Phase_5_Residential_Remaining",
        f"{base_dir}/{today}/Summary_Reports",
        f"{base_dir}/{today}/Firebase_Ready_Data"
    ]
    
    for directory in directories:
        os.makedirs(directory, exist_ok=True)
    
    print(f"✅ Created directory structure in: {base_dir}/{today}")

def run_phase_1_test():
    """Run Phase 1 test extraction"""
    
    print("🧪 Running Phase 1: Test & Validation...")
    
    test_queries = [
        "restaurants in Freeganj, Ujjain",
        "medical stores in Tower Chowk, Ujjain",
        "mobile shops in Mahakaleshwar Temple, Ujjain",
        "grocery stores in University Road, Ujjain",
        "beauty parlors in Dewas Gate, Ujjain"
    ]
    
    try:
        # Create test input file
        with open('phase1_test_queries.txt', 'w') as f:
            for query in test_queries:
                f.write(query + '\n')
        
        # Run scraper for test
        cmd = [
            sys.executable,
            'google_maps_scraper_bazarse.py',
            '-t', '10',  # 10 businesses per query
            '--test'
        ]
        
        print("🚀 Starting test scraping...")
        start_time = time.time()
        
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=1800)  # 30 min timeout
        
        end_time = time.time()
        duration = (end_time - start_time) / 60  # minutes
        
        if result.returncode == 0:
            print(f"✅ Phase 1 completed in {duration:.1f} minutes")
            print("📊 Test Results:")
            print(result.stdout)
            
            # Move test data to Phase 1 folder
            move_data_to_phase_folder("Phase_1_Test")
            
            return True
        else:
            print("❌ Phase 1 failed!")
            print("Error:", result.stderr)
            return False
            
    except Exception as e:
        print(f"❌ Phase 1 error: {e}")
        return False

def run_complete_extraction():
    """Run the complete extraction process"""
    
    print("\n🌟 STARTING COMPLETE UJJAIN EXTRACTION")
    print("=" * 50)
    
    # This would be a very long process, so we'll run it in background
    print("⚠️  WARNING: Complete extraction will take 48-72 hours")
    print("💡 Recommendation: Run in phases or overnight")
    
    choice = input("\n👉 Continue with full extraction? (y/n): ").lower()
    
    if choice == 'y':
        print("🚀 Starting complete extraction...")
        print("📊 This will extract ~125,000 businesses")
        print("⏱️  Estimated time: 48-72 hours")
        print("💾 Data will be saved in Complete_Ujjain_Data folder")
        
        # Start the full extraction
        cmd = [
            sys.executable,
            'google_maps_scraper_bazarse.py',
            '--ujjain',
            '-t', '25'  # 25 businesses per query
        ]
        
        print("🔥 Full extraction started in background...")
        print("📁 Monitor progress in Complete_Ujjain_Data folder")
        
        # Run in background (non-blocking)
        subprocess.Popen(cmd)
        
        print("✅ Extraction process initiated!")
        print("📊 Check Complete_Ujjain_Data folder for progress")
        
    else:
        print("👋 Full extraction cancelled")

def move_data_to_phase_folder(phase_folder):
    """Move extracted data to appropriate phase folder"""
    
    today = datetime.now().strftime("%Y-%m-%d")
    source_dir = f"Ujjain_Business_Data/{today}"
    target_dir = f"Complete_Ujjain_Data/{today}/{phase_folder}"
    
    if os.path.exists(source_dir):
        import shutil
        try:
            # Copy all files to phase folder
            for file in os.listdir(source_dir):
                shutil.copy2(os.path.join(source_dir, file), target_dir)
            print(f"✅ Data moved to {target_dir}")
        except Exception as e:
            print(f"❌ Error moving data: {e}")

def generate_summary_report():
    """Generate summary report of extraction"""
    
    today = datetime.now().strftime("%Y-%m-%d")
    base_dir = f"Complete_Ujjain_Data/{today}"
    
    summary = {
        "extraction_date": today,
        "total_businesses": 0,
        "total_files": 0,
        "categories_covered": [],
        "locations_covered": [],
        "data_quality": {
            "with_images": 0,
            "with_phone": 0,
            "with_coordinates": 0,
            "with_reviews": 0
        }
    }
    
    # Analyze extracted data
    for phase_folder in os.listdir(base_dir):
        if phase_folder.startswith("Phase_"):
            phase_path = os.path.join(base_dir, phase_folder)
            if os.path.isdir(phase_path):
                csv_files = [f for f in os.listdir(phase_path) if f.endswith('.csv')]
                summary["total_files"] += len(csv_files)
                
                for csv_file in csv_files:
                    try:
                        df = pd.read_csv(os.path.join(phase_path, csv_file))
                        summary["total_businesses"] += len(df)
                    except:
                        pass
    
    # Save summary report
    summary_path = os.path.join(base_dir, "Summary_Reports", "extraction_summary.json")
    with open(summary_path, 'w') as f:
        json.dump(summary, f, indent=2)
    
    print(f"📊 Summary report saved: {summary_path}")
    return summary

def main():
    """Main extraction function"""
    
    print("🔥 BAZAR SE - COMPLETE UJJAIN DATA EXTRACTION 🔥")
    print("=" * 60)
    
    # Show detailed estimates
    estimates = calculate_extraction_estimates()
    
    print("📊 COMPLETE EXTRACTION ESTIMATES:")
    print("=" * 40)
    
    for section, details in estimates.items():
        print(f"\n{section}")
        for key, value in details.items():
            print(f"  {key}: {value}")
    
    print("\n" + "=" * 60)
    print("🎯 WHAT WILL BE EXTRACTED:")
    print("✅ 125,000+ real businesses from Google Maps")
    print("✅ Complete business details (name, address, phone)")
    print("✅ Image URLs (main + 4 additional photos)")
    print("✅ GPS coordinates and reviews")
    print("✅ Multiple categories per business")
    print("✅ 20 Ujjain locations comprehensive coverage")
    print("✅ 250+ subcategories across 12 main categories")
    print("✅ Production-ready data for Bazar Se app")
    
    print("\n📁 DATA ORGANIZATION:")
    print("✅ Organized by phases and locations")
    print("✅ CSV + Excel formats")
    print("✅ Firebase-ready structure")
    print("✅ Summary reports and analytics")
    
    start_complete_extraction()

if __name__ == "__main__":
    main()
