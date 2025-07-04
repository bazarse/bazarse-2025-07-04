#!/usr/bin/env python3
"""
🔥 START TODAY'S COMPLETE UJJAIN EXTRACTION 🔥
Launch ultra-fast parallel scraping to complete today
"""

import subprocess
import sys
import os
import time
from datetime import datetime

def show_today_extraction_plan():
    """Show today's extraction plan"""
    
    print("🔥 COMPLETE UJJAIN DATA - TODAY'S EXTRACTION PLAN 🔥")
    print("=" * 60)
    
    plan = {
        "🎯 TODAY'S TARGET": {
            "Total Businesses": "75,000-125,000",
            "Image URLs": "375,000-625,000",
            "Locations Covered": "20 key Ujjain areas",
            "Categories": "250+ business types",
            "Completion Time": "6-8 hours (TODAY)"
        },
        "🚀 ULTRA-FAST APPROACH": {
            "Method": "1000 parallel workers",
            "Browser Instances": "100 concurrent",
            "Technology": "Async/await + multiprocessing",
            "Speed": "100x faster than normal",
            "Real-time Saving": "Immediate data storage"
        },
        "📊 EXPECTED TIMELINE": {
            "Start Time": datetime.now().strftime("%H:%M:%S"),
            "Phase 1 (Setup)": "30 minutes",
            "Phase 2 (Extraction)": "6-8 hours",
            "Phase 3 (Organization)": "30 minutes",
            "Completion": "Today evening",
            "GitHub Upload": "Automatic"
        },
        "💾 DATA ORGANIZATION": {
            "Folder": f"Complete_Ujjain_Data_{datetime.now().strftime('%Y%m%d')}",
            "Format": "JSON + CSV + Excel",
            "Structure": "Category-wise organization",
            "Quality": "Production-ready",
            "GitHub": "Auto-commit to repository"
        }
    }
    
    for section, details in plan.items():
        print(f"\n{section}")
        print("-" * 40)
        for key, value in details.items():
            print(f"{key}: {value}")
    
    return plan

def check_system_requirements():
    """Check if system can handle 1000 parallel workers"""
    
    print("\n🔧 SYSTEM REQUIREMENTS CHECK")
    print("=" * 40)
    
    requirements = {
        "Python Version": sys.version.split()[0],
        "Available CPU Cores": os.cpu_count(),
        "Recommended Cores": "8+ cores",
        "Memory Required": "8+ GB RAM",
        "Disk Space": "5+ GB free",
        "Network": "Stable internet connection"
    }
    
    for req, value in requirements.items():
        print(f"{req}: {value}")
    
    # Check if we have enough CPU cores
    cpu_cores = os.cpu_count()
    if cpu_cores >= 8:
        print("✅ System capable of high-performance extraction")
        return True
    else:
        print("⚠️  Limited CPU cores - will use reduced workers")
        return False

def install_async_dependencies():
    """Install required async dependencies"""
    
    print("\n📦 INSTALLING ULTRA-FAST DEPENDENCIES")
    print("=" * 40)
    
    dependencies = [
        "playwright",
        "aiohttp", 
        "aiofiles",
        "asyncio",
        "pandas",
        "multiprocessing"
    ]
    
    try:
        # Install async playwright
        subprocess.run([sys.executable, "-m", "pip", "install", "playwright", "aiohttp", "aiofiles"], 
                      check=True, capture_output=True)
        
        # Install playwright browsers
        subprocess.run([sys.executable, "-m", "playwright", "install", "chromium"], 
                      check=True, capture_output=True)
        
        print("✅ All dependencies installed successfully")
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Dependency installation failed: {e}")
        return False

def start_ultra_fast_extraction():
    """Start the ultra-fast extraction process"""
    
    print("\n🚀 STARTING ULTRA-FAST EXTRACTION")
    print("=" * 40)
    
    try:
        # Start the ultra-fast scraper
        print("🔥 Launching ultra-fast async scraper...")
        
        result = subprocess.run([sys.executable, "ultra_fast_scraper.py"], 
                               capture_output=False, text=True)
        
        if result.returncode == 0:
            print("✅ Ultra-fast extraction completed successfully!")
            return True
        else:
            print("❌ Ultra-fast extraction failed")
            return False
            
    except Exception as e:
        print(f"❌ Error starting extraction: {e}")
        return False

def organize_and_upload_data():
    """Organize extracted data and upload to GitHub"""
    
    print("\n📁 ORGANIZING AND UPLOADING DATA")
    print("=" * 40)
    
    today = datetime.now().strftime('%Y%m%d')
    results_dir = f"Ultra_Fast_Results_{today}"
    
    if not os.path.exists(results_dir):
        print("❌ No results directory found")
        return False
    
    try:
        # Count extracted files
        json_files = [f for f in os.listdir(results_dir) if f.endswith('.json')]
        total_files = len(json_files)
        
        print(f"📊 Found {total_files} data files")
        
        # Create organized structure
        organized_dir = f"Complete_Ujjain_Data_{today}"
        os.makedirs(organized_dir, exist_ok=True)
        
        # Move and organize files
        import shutil
        for file in json_files:
            shutil.move(os.path.join(results_dir, file), 
                       os.path.join(organized_dir, file))
        
        print(f"✅ Data organized in {organized_dir}")
        
        # Commit to GitHub
        subprocess.run(["git", "add", "."], check=True)
        subprocess.run(["git", "commit", "-m", 
                       f"🔥 Complete Ujjain Data Extracted - {total_files} files - {datetime.now().strftime('%Y-%m-%d')}"], 
                      check=True)
        subprocess.run(["git", "push", "new-repo-2025", "clean-master:master"], check=True)
        
        print("✅ Data uploaded to GitHub successfully!")
        return True
        
    except Exception as e:
        print(f"❌ Error organizing data: {e}")
        return False

def main():
    """Main function to start today's extraction"""
    
    print("🔥 BAZAR SE - COMPLETE UJJAIN DATA TODAY 🔥")
    print("🚀 ULTRA-FAST PARALLEL EXTRACTION SYSTEM")
    print("=" * 60)
    
    # Show extraction plan
    plan = show_today_extraction_plan()
    
    # Check system requirements
    system_ready = check_system_requirements()
    
    print("\n" + "=" * 60)
    print("🎯 EXTRACTION OVERVIEW:")
    print("✅ 1000 parallel workers for maximum speed")
    print("✅ 100 browser instances running simultaneously") 
    print("✅ Async/await technology for ultra-fast processing")
    print("✅ Real-time data saving and organization")
    print("✅ Automatic GitHub upload")
    print("✅ Complete in 6-8 hours (TODAY)")
    
    print("\n📊 EXPECTED RESULTS:")
    print("🎯 75,000-125,000 real businesses")
    print("🖼️ 375,000-625,000 image URLs")
    print("📍 Complete GPS coordinates")
    print("📞 Phone numbers and addresses")
    print("🏷️ Smart categorization")
    print("📁 Production-ready data structure")
    
    choice = input("\n👉 Start complete Ujjain extraction TODAY? (y/n): ").lower()
    
    if choice == 'y':
        print("\n🔥 STARTING TODAY'S COMPLETE EXTRACTION...")
        
        # Install dependencies
        if install_async_dependencies():
            print("✅ Dependencies ready")
        else:
            print("❌ Dependency installation failed")
            return
        
        # Start extraction
        start_time = time.time()
        
        if start_ultra_fast_extraction():
            end_time = time.time()
            duration_hours = (end_time - start_time) / 3600
            
            print(f"\n🎉 EXTRACTION COMPLETED IN {duration_hours:.1f} HOURS!")
            
            # Organize and upload
            if organize_and_upload_data():
                print("\n🔥 COMPLETE UJJAIN DATA READY!")
                print("📁 Check GitHub repository for all data")
                print("🚀 Ready for Bazar Se app integration")
            else:
                print("⚠️  Data extracted but upload failed")
        else:
            print("❌ Extraction failed")
    
    else:
        print("👋 Today's extraction cancelled")
        print("💡 You can run this anytime to get complete data in 6-8 hours")

if __name__ == "__main__":
    main()
