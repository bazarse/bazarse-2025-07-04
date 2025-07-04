#!/usr/bin/env python3
"""
🔥 GOOGLE MAPS SCRAPER FOR BAZAR SE - UJJAIN BUSINESS DATA EXTRACTOR 🔥
Customized version of kevmaindev's scraper for Bazar Se project
"""

import datetime
from playwright.sync_api import sync_playwright
from dataclasses import dataclass, asdict, field
import pandas as pd
import argparse
import os
import sys
import json
import time
import firebase_admin
from firebase_admin import credentials, firestore

@dataclass
class Business:
    """Enhanced business data structure for Bazar Se"""
    name: str = None
    address: str = None
    domain: str = None
    website: str = None
    phone_number: str = None
    categories: list = field(default_factory=list)  # Multiple categories
    subcategories: list = field(default_factory=list)  # Multiple subcategories
    primary_category: str = None
    primary_subcategory: str = None
    location: str = None
    area: str = None  # Specific area in Ujjain
    city: str = "Ujjain"
    state: str = "Madhya Pradesh"
    reviews_count: int = None
    reviews_average: float = None
    latitude: float = None
    longitude: float = None
    google_place_id: str = None
    business_status: str = "OPERATIONAL"
    price_level: int = None
    opening_hours: str = None
    image_url: str = None  # Main business image
    photos: list = field(default_factory=list)  # Additional photos
    google_types: list = field(default_factory=list)  # Google's business types
    verified: bool = False
    claimed: bool = False
    source: str = "google_maps_scraper"
    scraped_at: str = field(default_factory=lambda: datetime.datetime.now().isoformat())

    def __hash__(self):
        """Make Business hashable for duplicate detection"""
        hash_fields = [self.name, self.address]
        if self.phone_number:
            hash_fields.append(f"phone:{self.phone_number}")
        return hash(tuple(hash_fields))

@dataclass
class BusinessList:
    """Enhanced business list with Firebase integration"""
    business_list: list[Business] = field(default_factory=list)
    _seen_businesses: set = field(default_factory=set, init=False)
    
    today = datetime.datetime.now().strftime("%Y-%m-%d")
    save_at = os.path.join('Ujjain_Business_Data', today)
    os.makedirs(save_at, exist_ok=True)

    def add_business(self, business: Business):
        """Add business with duplicate detection"""
        business_hash = hash(business)
        if business_hash not in self._seen_businesses:
            self.business_list.append(business)
            self._seen_businesses.add(business_hash)
            return True
        return False

    def dataframe(self):
        """Convert to pandas dataframe"""
        return pd.json_normalize(
            (asdict(business) for business in self.business_list), 
            sep="_"
        )

    def save_to_excel(self, filename):
        """Save to Excel with Bazar Se formatting"""
        df = self.dataframe()
        filepath = f"{self.save_at}/{filename}.xlsx"
        df.to_excel(filepath, index=False)
        print(f"✅ Excel saved: {filepath}")

    def save_to_csv(self, filename):
        """Save to CSV with Bazar Se formatting"""
        df = self.dataframe()
        filepath = f"{self.save_at}/{filename}.csv"
        df.to_csv(filepath, index=False)
        print(f"✅ CSV saved: {filepath}")

    def save_to_firebase(self, collection_name="ujjain_businesses"):
        """Save directly to Firebase Firestore"""
        try:
            # Initialize Firebase (you'll need to add your service account key)
            if not firebase_admin._apps:
                # Add your Firebase service account key path here
                cred = credentials.Certificate("bazarse-service-account.json")
                firebase_admin.initialize_app(cred)
            
            db = firestore.client()
            
            success_count = 0
            for business in self.business_list:
                try:
                    # Convert to dict and clean None values
                    business_data = {k: v for k, v in asdict(business).items() if v is not None}
                    
                    # Add to Firestore
                    doc_ref = db.collection(collection_name).add(business_data)
                    success_count += 1
                    print(f"✅ Added to Firebase: {business.name}")
                    
                except Exception as e:
                    print(f"❌ Firebase error for {business.name}: {e}")
            
            print(f"🎉 Successfully added {success_count}/{len(self.business_list)} businesses to Firebase!")
            
        except Exception as e:
            print(f"❌ Firebase connection error: {e}")

def extract_coordinates_from_url(url: str) -> tuple[float, float]:
    """Extract coordinates from Google Maps URL"""
    try:
        coordinates = url.split('/@')[-1].split('/')[0]
        lat, lng = coordinates.split(',')[:2]
        return float(lat), float(lng)
    except:
        return None, None

def get_ujjain_locations():
    """Get 20 key locations in Ujjain for comprehensive coverage"""
    locations = [
        "Freeganj, Ujjain",
        "Mahakaleshwar Temple, Ujjain",
        "Tower Chowk, Ujjain",
        "Dewas Gate, Ujjain",
        "University Road, Ujjain",
        "Agar Road, Ujjain",
        "Indore Road, Ujjain",
        "Railway Station Road, Ujjain",
        "Nanakheda, Ujjain",
        "Chimanganj Mandi, Ujjain",
        "Jiwaji University, Ujjain",
        "Kshipra Pul, Ujjain",
        "Ramghat Road, Ujjain",
        "Vikram University, Ujjain",
        "Madhav Nagar, Ujjain",
        "Kalbhairav Temple, Ujjain",
        "Sandipani Ashram, Ujjain",
        "Triveni Museum, Ujjain",
        "Bharti Nagar, Ujjain",
        "Jaisinghpura, Ujjain"
    ]
    return locations

def get_comprehensive_subcategories():
    """Get all 250+ subcategories for Bazar Se"""
    subcategories = {
        "🍽️ FOOD & DINING": [
            "restaurants", "fast food", "street food", "sweet shops", "bakeries",
            "ice cream parlors", "juice centers", "tea stalls", "coffee shops",
            "dhaba", "pure veg restaurants", "non veg restaurants", "chinese food",
            "south indian food", "punjabi food", "gujarati food", "rajasthani food",
            "pizza", "burger joints", "chat centers", "lassi shops"
        ],
        "🛒 GROCERY & DAILY": [
            "kirana stores", "supermarkets", "grocery stores", "general stores",
            "provision stores", "departmental stores", "wholesale grocery",
            "organic stores", "spice shops", "dry fruits", "flour mills",
            "oil stores", "dairy products", "frozen foods", "packaged foods"
        ],
        "🏥 HEALTH & MEDICAL": [
            "hospitals", "clinics", "medical stores", "pharmacies", "dental clinics",
            "eye clinics", "skin clinics", "pediatric clinics", "gynecology clinics",
            "orthopedic clinics", "cardiology clinics", "diagnostic centers",
            "pathology labs", "x-ray centers", "physiotherapy centers", "ayurvedic centers",
            "homeopathic clinics", "unani medicine", "veterinary clinics"
        ],
        "👗 FASHION & RETAIL": [
            "clothing stores", "saree shops", "suit shops", "shirt shops",
            "jeans shops", "kids wear", "ladies wear", "mens wear",
            "ethnic wear", "western wear", "footwear", "shoe stores",
            "sandal shops", "sports shoes", "formal shoes", "bags",
            "handbags", "luggage", "accessories", "jewelry", "artificial jewelry",
            "gold jewelry", "silver jewelry", "watches", "sunglasses"
        ],
        "📱 ELECTRONICS & TECH": [
            "mobile shops", "electronics stores", "computer shops", "laptop stores",
            "mobile accessories", "mobile repair", "computer repair", "tv repair",
            "ac repair", "refrigerator repair", "washing machine repair",
            "electronics wholesale", "camera shops", "music systems", "home appliances",
            "kitchen appliances", "fans", "lights", "electrical goods"
        ],
        "💄 BEAUTY & CARE": [
            "beauty parlors", "salons", "hair cutting", "beauty treatments",
            "facial centers", "massage centers", "spa", "nail art",
            "bridal makeup", "cosmetics", "perfumes", "hair care products",
            "skin care products", "beauty products", "herbal beauty"
        ],
        "🏠 HOME & LIVING": [
            "furniture stores", "home decor", "curtains", "carpets", "rugs",
            "bedsheets", "pillows", "mattresses", "sofas", "chairs",
            "tables", "wardrobes", "kitchen furniture", "office furniture",
            "interior design", "paint shops", "hardware stores", "plumbing",
            "electrical supplies", "tiles", "marble", "granite"
        ],
        "🚗 AUTOMOTIVE & TRANSPORT": [
            "petrol pumps", "auto repair", "car service", "bike service",
            "tire shops", "auto parts", "car accessories", "bike accessories",
            "car wash", "auto insurance", "driving schools", "taxi services",
            "auto rickshaw", "transport services", "logistics", "courier services"
        ],
        "🎓 EDUCATION & TRAINING": [
            "schools", "colleges", "coaching centers", "tuition centers",
            "computer training", "english speaking", "skill development",
            "vocational training", "music classes", "dance classes",
            "art classes", "sports coaching", "driving schools", "libraries",
            "book stores", "stationery", "educational supplies"
        ],
        "💼 BUSINESS & PROFESSIONAL": [
            "banks", "atms", "insurance", "ca offices", "lawyers", "consultants",
            "real estate", "property dealers", "architects", "engineers",
            "contractors", "advertising agencies", "printing press", "xerox",
            "internet cafes", "business centers", "co-working spaces"
        ],
        "🏨 TRAVEL & STAY": [
            "hotels", "guest houses", "lodges", "resorts", "dharamshalas",
            "travel agencies", "tour operators", "bus booking", "train booking",
            "flight booking", "taxi booking", "car rental", "bike rental"
        ],
        "🎪 ENTERTAINMENT & EVENTS": [
            "cinemas", "theaters", "event management", "wedding planners",
            "decorators", "caterers", "dj services", "band services",
            "photography", "videography", "party halls", "banquet halls",
            "clubs", "pubs", "gaming zones", "sports clubs"
        ]
    }
    return subcategories

def get_ujjain_search_queries():
    """Generate comprehensive search queries for all subcategories in all locations"""
    locations = get_ujjain_locations()
    subcategories = get_comprehensive_subcategories()

    queries = []

    # Generate queries for each subcategory in each location
    for category, subcat_list in subcategories.items():
        for subcategory in subcat_list:
            for location in locations:
                queries.append(f"{subcategory} in {location}")

    # Add general Ujjain queries
    for category, subcat_list in subcategories.items():
        for subcategory in subcat_list:
            queries.append(f"{subcategory} in Ujjain")

    return queries

def categorize_business(search_query, business_name, google_types=None):
    """Advanced categorization with multiple categories and subcategories"""

    # Enhanced category mapping
    category_mapping = {
        # Food & Dining
        "restaurant": ("🍽️ FOOD & DINING", "Restaurants"),
        "fast food": ("🍽️ FOOD & DINING", "Fast Food"),
        "sweet": ("🍽️ FOOD & DINING", "Sweet Shops"),
        "bakery": ("🍽️ FOOD & DINING", "Bakeries"),
        "ice cream": ("🍽️ FOOD & DINING", "Ice Cream Parlors"),
        "juice": ("🍽️ FOOD & DINING", "Juice Centers"),
        "tea": ("🍽️ FOOD & DINING", "Tea Stalls"),
        "coffee": ("🍽️ FOOD & DINING", "Coffee Shops"),
        "dhaba": ("🍽️ FOOD & DINING", "Dhaba"),
        "pizza": ("🍽️ FOOD & DINING", "Pizza"),
        "burger": ("🍽️ FOOD & DINING", "Burger Joints"),
        "chat": ("🍽️ FOOD & DINING", "Chat Centers"),

        # Grocery & Daily
        "kirana": ("🛒 GROCERY & DAILY", "Kirana Stores"),
        "grocery": ("🛒 GROCERY & DAILY", "Grocery Stores"),
        "supermarket": ("🛒 GROCERY & DAILY", "Supermarkets"),
        "general store": ("🛒 GROCERY & DAILY", "General Stores"),
        "provision": ("🛒 GROCERY & DAILY", "Provision Stores"),
        "spice": ("🛒 GROCERY & DAILY", "Spice Shops"),
        "flour mill": ("🛒 GROCERY & DAILY", "Flour Mills"),

        # Health & Medical
        "hospital": ("🏥 HEALTH & MEDICAL", "Hospitals"),
        "clinic": ("🏥 HEALTH & MEDICAL", "Clinics"),
        "medical": ("🏥 HEALTH & MEDICAL", "Medical Stores"),
        "pharmacy": ("🏥 HEALTH & MEDICAL", "Pharmacies"),
        "dental": ("🏥 HEALTH & MEDICAL", "Dental Clinics"),
        "eye": ("🏥 HEALTH & MEDICAL", "Eye Clinics"),
        "skin": ("🏥 HEALTH & MEDICAL", "Skin Clinics"),
        "diagnostic": ("🏥 HEALTH & MEDICAL", "Diagnostic Centers"),
        "pathology": ("🏥 HEALTH & MEDICAL", "Pathology Labs"),
        "ayurvedic": ("🏥 HEALTH & MEDICAL", "Ayurvedic Centers"),

        # Fashion & Retail
        "clothing": ("👗 FASHION & RETAIL", "Clothing Stores"),
        "saree": ("👗 FASHION & RETAIL", "Saree Shops"),
        "suit": ("👗 FASHION & RETAIL", "Suit Shops"),
        "footwear": ("👗 FASHION & RETAIL", "Footwear"),
        "shoe": ("👗 FASHION & RETAIL", "Shoe Stores"),
        "bag": ("👗 FASHION & RETAIL", "Bags"),
        "jewelry": ("👗 FASHION & RETAIL", "Jewelry"),
        "jewellery": ("👗 FASHION & RETAIL", "Jewelry"),
        "watch": ("👗 FASHION & RETAIL", "Watches"),

        # Electronics & Tech
        "mobile": ("📱 ELECTRONICS & TECH", "Mobile Shops"),
        "electronics": ("📱 ELECTRONICS & TECH", "Electronics Stores"),
        "computer": ("📱 ELECTRONICS & TECH", "Computer Shops"),
        "laptop": ("📱 ELECTRONICS & TECH", "Laptop Stores"),
        "repair": ("📱 ELECTRONICS & TECH", "Repair Services"),
        "appliance": ("📱 ELECTRONICS & TECH", "Home Appliances"),

        # Beauty & Care
        "beauty": ("💄 BEAUTY & CARE", "Beauty Parlors"),
        "salon": ("💄 BEAUTY & CARE", "Salons"),
        "parlor": ("💄 BEAUTY & CARE", "Beauty Parlors"),
        "parlour": ("💄 BEAUTY & CARE", "Beauty Parlors"),
        "spa": ("💄 BEAUTY & CARE", "Spa"),
        "cosmetic": ("💄 BEAUTY & CARE", "Cosmetics"),

        # Home & Living
        "furniture": ("🏠 HOME & LIVING", "Furniture Stores"),
        "hardware": ("🏠 HOME & LIVING", "Hardware Stores"),
        "paint": ("🏠 HOME & LIVING", "Paint Shops"),
        "tile": ("🏠 HOME & LIVING", "Tiles"),
        "marble": ("🏠 HOME & LIVING", "Marble"),

        # Automotive & Transport
        "petrol": ("🚗 AUTOMOTIVE & TRANSPORT", "Petrol Pumps"),
        "auto": ("🚗 AUTOMOTIVE & TRANSPORT", "Auto Repair"),
        "car": ("🚗 AUTOMOTIVE & TRANSPORT", "Car Service"),
        "bike": ("🚗 AUTOMOTIVE & TRANSPORT", "Bike Service"),
        "tire": ("🚗 AUTOMOTIVE & TRANSPORT", "Tire Shops"),
        "transport": ("🚗 AUTOMOTIVE & TRANSPORT", "Transport Services"),

        # Education & Training
        "school": ("🎓 EDUCATION & TRAINING", "Schools"),
        "college": ("🎓 EDUCATION & TRAINING", "Colleges"),
        "coaching": ("🎓 EDUCATION & TRAINING", "Coaching Centers"),
        "tuition": ("🎓 EDUCATION & TRAINING", "Tuition Centers"),
        "book": ("🎓 EDUCATION & TRAINING", "Book Stores"),
        "stationery": ("🎓 EDUCATION & TRAINING", "Stationery"),

        # Business & Professional
        "bank": ("💼 BUSINESS & PROFESSIONAL", "Banks"),
        "atm": ("💼 BUSINESS & PROFESSIONAL", "ATMs"),
        "insurance": ("💼 BUSINESS & PROFESSIONAL", "Insurance"),
        "lawyer": ("💼 BUSINESS & PROFESSIONAL", "Lawyers"),
        "real estate": ("💼 BUSINESS & PROFESSIONAL", "Real Estate"),
        "property": ("💼 BUSINESS & PROFESSIONAL", "Property Dealers"),

        # Travel & Stay
        "hotel": ("🏨 TRAVEL & STAY", "Hotels"),
        "guest house": ("🏨 TRAVEL & STAY", "Guest Houses"),
        "lodge": ("🏨 TRAVEL & STAY", "Lodges"),
        "travel": ("🏨 TRAVEL & STAY", "Travel Agencies"),
        "tour": ("🏨 TRAVEL & STAY", "Tour Operators"),
    }

    # Find matching categories
    categories = []
    subcategories = []

    search_lower = search_query.lower()
    name_lower = (business_name or "").lower()

    for keyword, (category, subcategory) in category_mapping.items():
        if keyword in search_lower or keyword in name_lower:
            if category not in categories:
                categories.append(category)
            if subcategory not in subcategories:
                subcategories.append(subcategory)

    # If no match found, use Google types
    if not categories and google_types:
        for gtype in google_types:
            if gtype in category_mapping:
                category, subcategory = category_mapping[gtype]
                if category not in categories:
                    categories.append(category)
                if subcategory not in subcategories:
                    subcategories.append(subcategory)

    # Default fallback
    if not categories:
        categories = ["💼 BUSINESS & PROFESSIONAL"]
        subcategories = ["General Business"]

    return categories, subcategories

def main():
    print("🔥 BAZAR SE - UJJAIN BUSINESS DATA SCRAPER 🔥")
    print("=" * 60)
    
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--search", type=str, help="Single search query")
    parser.add_argument("-t", "--total", type=int, default=50, help="Max results per search")
    parser.add_argument("--firebase", action="store_true", help="Save to Firebase")
    parser.add_argument("--ujjain", action="store_true", help="Use predefined Ujjain queries")
    parser.add_argument("--test", action="store_true", help="Test mode with limited queries")
    args = parser.parse_args()

    # Determine search list
    if args.test:
        # Test mode with limited queries
        input_file = 'test_queries.txt'
        if os.path.exists(input_file):
            with open(input_file, 'r') as file:
                search_list = [line.strip() for line in file.readlines() if line.strip()]
            print(f"🧪 TEST MODE: Using {len(search_list)} test queries")
        else:
            print("❌ Test queries file not found. Run test_scraper.py first")
            sys.exit()
    elif args.ujjain:
        search_list = get_ujjain_search_queries()
        print(f"🎯 Using {len(search_list)} comprehensive Ujjain business queries")
        print(f"📊 This will take 15-20 hours to complete all locations and categories")
    elif args.search:
        search_list = [args.search]
    else:
        # Read from input.txt
        input_file = 'ujjain_business_queries.txt'
        if os.path.exists(input_file):
            with open(input_file, 'r') as file:
                search_list = [line.strip() for line in file.readlines() if line.strip()]
        else:
            print("❌ No search queries found. Use --ujjain, --test, or provide -s argument")
            sys.exit()

    total_businesses = 0
    
    with sync_playwright() as p:
        print("🚀 Starting browser...")
        browser = p.chromium.launch(headless=False)  # Set to True for headless
        page = browser.new_page(locale="en-GB")
        page.goto("https://www.google.com/maps", timeout=20000)
        
        for search_index, search_query in enumerate(search_list):
            print(f"\n📍 {search_index + 1}/{len(search_list)} - {search_query}")
            
            # Search on Google Maps
            page.locator('//input[@id="searchboxinput"]').fill(search_query)
            page.wait_for_timeout(3000)
            page.keyboard.press("Enter")
            page.wait_for_timeout(5000)

            # Scroll to load more results
            page.hover('//a[contains(@href, "https://www.google.com/maps/place")]')
            previously_counted = 0
            
            while True:
                page.mouse.wheel(0, 10000)
                page.wait_for_timeout(3000)
                
                current_count = page.locator('//a[contains(@href, "https://www.google.com/maps/place")]').count()
                
                if current_count >= args.total:
                    listings = page.locator('//a[contains(@href, "https://www.google.com/maps/place")]').all()[:args.total]
                    break
                elif current_count == previously_counted:
                    listings = page.locator('//a[contains(@href, "https://www.google.com/maps/place")]').all()
                    break
                else:
                    previously_counted = current_count
                    print(f"📊 Loading... {current_count} businesses found", end='\r')

            print(f"✅ Found {len(listings)} businesses for {search_query}")
            
            business_list = BusinessList()
            
            # Extract business data
            for listing_index, listing in enumerate(listings):
                try:
                    listing.click()
                    page.wait_for_timeout(2000)
                    
                    business = Business()
                    
                    # Extract business details
                    if name_elem := page.locator('h1.DUwDvf').first:
                        business.name = name_elem.inner_text().strip()

                    if address_elem := page.locator('//button[@data-item-id="address"]//div[contains(@class, "fontBodyMedium")]').first:
                        business.address = address_elem.inner_text().strip()

                    if website_elem := page.locator('//a[@data-item-id="authority"]//div[contains(@class, "fontBodyMedium")]').first:
                        business.domain = website_elem.inner_text().strip()
                        business.website = f"https://www.{business.domain}"

                    if phone_elem := page.locator('//button[contains(@data-item-id, "phone:tel:")]//div[contains(@class, "fontBodyMedium")]').first:
                        business.phone_number = phone_elem.inner_text().strip()

                    if review_count_elem := page.locator('//div[@jsaction="pane.reviewChart.moreReviews"]//span').first:
                        try:
                            business.reviews_count = int(review_count_elem.inner_text().split()[0].replace(',', ''))
                        except:
                            pass

                    if rating_elem := page.locator('//div[@jsaction="pane.reviewChart.moreReviews"]//div[@role="img"]').first:
                        try:
                            business.reviews_average = float(rating_elem.get_attribute('aria-label').split()[0].replace(',', '.'))
                        except:
                            pass

                    # Extract main business image
                    try:
                        # Try to get the main business photo
                        photo_elem = page.locator('//div[contains(@class, "ZKCDEc")]//img').first
                        if photo_elem:
                            business.image_url = photo_elem.get_attribute('src')

                        # Get additional photos
                        photo_elems = page.locator('//div[contains(@class, "ZKCDEc")]//img').all()[:5]
                        business.photos = [elem.get_attribute('src') for elem in photo_elems if elem.get_attribute('src')]
                    except:
                        pass

                    # Extract opening hours
                    try:
                        hours_elem = page.locator('//div[contains(@class, "OqCZI")]//div[contains(@class, "fontBodyMedium")]').first
                        if hours_elem:
                            business.opening_hours = hours_elem.inner_text().strip()
                    except:
                        pass

                    # Extract Google Place ID from URL
                    try:
                        url_parts = page.url.split('/')
                        for part in url_parts:
                            if part.startswith('0x') and len(part) > 10:
                                business.google_place_id = part
                                break
                    except:
                        pass

                    # Set categories and location
                    categories, subcategories = categorize_business(search_query, business.name or "")
                    business.categories = categories
                    business.subcategories = subcategories
                    business.primary_category = categories[0] if categories else "💼 BUSINESS & PROFESSIONAL"
                    business.primary_subcategory = subcategories[0] if subcategories else "General Business"

                    # Extract area from search query or address
                    if " in " in search_query:
                        business.area = search_query.split(" in ")[-1].replace(", Ujjain", "").strip()
                    business.location = "Ujjain"

                    # Extract coordinates
                    business.latitude, business.longitude = extract_coordinates_from_url(page.url)
                    
                    # Add to list
                    if business_list.add_business(business):
                        total_businesses += 1
                        print(f"✅ {listing_index + 1}/{len(listings)} - {business.name}")
                    
                except Exception as e:
                    print(f"❌ Error extracting business {listing_index + 1}: {e}")
                    continue
            
            # Save data for this category
            filename = search_query.replace(' ', '_').replace('in_Ujjain', '').strip('_')
            business_list.save_to_csv(filename)
            business_list.save_to_excel(filename)
            
            if args.firebase:
                business_list.save_to_firebase(f"ujjain_businesses_{filename}")
            
            print(f"💾 Saved {len(business_list.business_list)} businesses for {search_query}")
        
        browser.close()
    
    print(f"\n🎉 SCRAPING COMPLETED!")
    print(f"📊 Total businesses extracted: {total_businesses}")
    print(f"📁 Data saved in: {BusinessList.save_at}")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n⏹️ Scraping stopped by user")
    except Exception as e:
        print(f"❌ Error: {e}")
