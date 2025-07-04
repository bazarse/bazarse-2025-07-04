# 🔥 Bazar Se - Complete Ujjain Business Data Scraper

**Enhanced Google Maps scraper with 20 locations, 250+ subcategories, and image extraction**

## 🎯 **What's New & Enhanced**

### ✅ **Image URL Extraction**
- Main business image from Google Maps
- Additional photos (up to 5 per business)
- High-quality image URLs for app display

### ✅ **Multiple Categories & Subcategories**
- Each business can have multiple categories
- 12 main categories with 250+ subcategories
- Smart categorization based on business type

### ✅ **20 Ujjain Locations Coverage**
- Freeganj, Tower Chowk, Dewas Gate
- Mahakaleshwar Temple, University Road
- Railway Station, Nanakheda, Chimanganj
- Complete city-wide coverage

### ✅ **Enhanced Data Structure**
```json
{
  "name": "Business Name",
  "address": "Complete Address",
  "phone_number": "+91 XXXXXXXXXX",
  "website": "https://website.com",
  "image_url": "https://maps.googleapis.com/...",
  "photos": ["url1", "url2", "url3"],
  "categories": ["🍽️ FOOD & DINING", "🛒 GROCERY & DAILY"],
  "subcategories": ["Restaurants", "Sweet Shops"],
  "primary_category": "🍽️ FOOD & DINING",
  "primary_subcategory": "Restaurants",
  "area": "Freeganj",
  "city": "Ujjain",
  "reviews_average": 4.5,
  "reviews_count": 150,
  "latitude": 23.1765,
  "longitude": 75.7885,
  "opening_hours": "9:00 AM - 10:00 PM",
  "google_place_id": "ChIJ...",
  "verified": true
}
```

## 📊 **Complete Category System**

### 🍽️ **FOOD & DINING** (20 subcategories)
- Restaurants, Fast Food, Sweet Shops, Bakeries
- Ice Cream Parlors, Juice Centers, Tea Stalls
- Coffee Shops, Dhaba, Pizza, Burger Joints

### 🛒 **GROCERY & DAILY** (15 subcategories)  
- Kirana Stores, Supermarkets, General Stores
- Provision Stores, Spice Shops, Flour Mills
- Organic Stores, Dairy Products

### 🏥 **HEALTH & MEDICAL** (19 subcategories)
- Hospitals, Clinics, Medical Stores, Pharmacies
- Dental, Eye, Skin Clinics, Diagnostic Centers
- Pathology Labs, Ayurvedic Centers

### 👗 **FASHION & RETAIL** (25 subcategories)
- Clothing, Saree, Suit Shops, Footwear
- Bags, Jewelry, Watches, Accessories
- Kids Wear, Ladies Wear, Mens Wear

### 📱 **ELECTRONICS & TECH** (18 subcategories)
- Mobile Shops, Electronics Stores, Computer Shops
- Laptop Stores, Mobile Repair, Home Appliances
- Kitchen Appliances, Electrical Goods

### 💄 **BEAUTY & CARE** (15 subcategories)
- Beauty Parlors, Salons, Hair Cutting
- Spa, Massage Centers, Cosmetics
- Bridal Makeup, Skin Care Products

### 🏠 **HOME & LIVING** (20 subcategories)
- Furniture, Home Decor, Curtains, Carpets
- Paint Shops, Hardware, Tiles, Marble
- Interior Design, Kitchen Furniture

### 🚗 **AUTOMOTIVE & TRANSPORT** (16 subcategories)
- Petrol Pumps, Auto Repair, Car Service
- Tire Shops, Auto Parts, Transport Services
- Taxi Services, Courier Services

### 🎓 **EDUCATION & TRAINING** (16 subcategories)
- Schools, Colleges, Coaching Centers
- Computer Training, Music Classes, Libraries
- Book Stores, Stationery

### 💼 **BUSINESS & PROFESSIONAL** (15 subcategories)
- Banks, ATMs, Insurance, CA Offices
- Lawyers, Real Estate, Architects
- Printing Press, Business Centers

### 🏨 **TRAVEL & STAY** (12 subcategories)
- Hotels, Guest Houses, Travel Agencies
- Tour Operators, Car Rental, Bus Booking

### 🎪 **ENTERTAINMENT & EVENTS** (14 subcategories)
- Cinemas, Event Management, Wedding Planners
- Photography, Party Halls, Gaming Zones

## 🗺️ **20 Ujjain Locations**

1. **Freeganj** - Main commercial area
2. **Mahakaleshwar Temple** - Religious center
3. **Tower Chowk** - Business district
4. **Dewas Gate** - Transport hub
5. **University Road** - Educational zone
6. **Agar Road** - Residential area
7. **Indore Road** - Highway commercial
8. **Railway Station Road** - Transport area
9. **Nanakheda** - Industrial area
10. **Chimanganj Mandi** - Wholesale market
11. **Jiwaji University** - Educational hub
12. **Kshipra Pul** - River area
13. **Ramghat Road** - Religious area
14. **Vikram University** - Academic zone
15. **Madhav Nagar** - Residential
16. **Kalbhairav Temple** - Religious
17. **Sandipani Ashram** - Spiritual center
18. **Triveni Museum** - Cultural area
19. **Bharti Nagar** - Residential
20. **Jaisinghpura** - Suburban area

## ⚡ **Quick Start Commands**

### 🧪 **Test Mode (Recommended First)**
```bash
python test_scraper.py
```
**Result**: 5 categories × 10 businesses = ~50 businesses in 15 minutes

### 🎯 **Single Category Test**
```bash
python google_maps_scraper_bazarse.py -s "restaurants in Freeganj, Ujjain" -t 20
```

### 🚀 **Complete Ujjain Data**
```bash
python google_maps_scraper_bazarse.py --ujjain -t 30
```
**Result**: 20 locations × 250+ subcategories × 30 businesses = 150,000+ businesses

### 🔥 **With Firebase Upload**
```bash
python google_maps_scraper_bazarse.py --ujjain --firebase -t 20
```

## 📈 **Expected Data Volume**

| Scope | Businesses | Time Required |
|-------|------------|---------------|
| **Test Mode** | 50 | 15 minutes |
| **Single Location** | 500-1000 | 2-3 hours |
| **5 Locations** | 2500-5000 | 8-12 hours |
| **Complete Ujjain** | 15,000-25,000 | 48-72 hours |

## 🔧 **Setup & Installation**

### 1. **Install Dependencies**
```bash
python setup_scraper.py
```

### 2. **Configure Firebase (Optional)**
- Download service account key
- Rename to `bazarse-service-account.json`

### 3. **Run Test**
```bash
python test_scraper.py
```

## 📁 **Output Structure**

```
Ujjain_Business_Data/
├── 2025-07-04/
│   ├── restaurants_in_Freeganj.csv
│   ├── restaurants_in_Freeganj.xlsx
│   ├── medical_stores_in_Tower_Chowk.csv
│   ├── mobile_shops_in_Dewas_Gate.csv
│   └── ... (thousands of files)
```

## 🎯 **Data Quality Features**

✅ **Duplicate Detection** - No repeated businesses  
✅ **Image Validation** - Working image URLs  
✅ **Phone Verification** - Indian format validation  
✅ **Address Cleaning** - Ujjain-specific addresses  
✅ **Category Mapping** - Smart multi-category assignment  
✅ **Coordinate Validation** - GPS bounds checking  

## 🚀 **Integration with Bazar Se**

### **Firebase Collections**
- `ujjain_businesses_food_dining`
- `ujjain_businesses_grocery_daily`
- `ujjain_businesses_health_medical`
- ... (one per category)

### **App Integration**
1. Import scraped data to Firebase
2. Map to your 25 categories
3. Add AI features and offers
4. Enable business verification
5. Launch with real data

## 📞 **Support & Troubleshooting**

**Common Issues:**
- Browser not opening → `playwright install chromium`
- Slow performance → Use `--headless` mode
- Firebase errors → Check service account key
- No results → Verify internet connection

---

**🎉 Ready to extract complete Ujjain business data!**

**Total Potential**: 25,000+ businesses with images and complete details  
**Categories**: 12 main categories, 250+ subcategories  
**Locations**: 20 key areas in Ujjain  
**Quality**: Real Google Maps data with images**
