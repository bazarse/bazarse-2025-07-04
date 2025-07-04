# 🔥 Bazar Se - Google Maps Scraper Guide

**Complete guide for scraping Ujjain business data using Google Maps**

## 🎯 **What This Scraper Does**

✅ **Extracts Real Business Data** from Google Maps  
✅ **Ujjain-Focused** with 30+ predefined categories  
✅ **Firebase Integration** - Direct upload to your database  
✅ **Duplicate Detection** - No repeated businesses  
✅ **Multiple Formats** - CSV, Excel, and Firebase  
✅ **Complete Business Info** - Name, address, phone, ratings, coordinates  

## 📊 **Data Fields Extracted**

```
✅ Business Name
✅ Full Address  
✅ Phone Number
✅ Website/Domain
✅ Google Reviews (count + average)
✅ GPS Coordinates (lat/lng)
✅ Business Category
✅ Operating Status
✅ Google Place ID
```

## ⚡ **Quick Setup**

### 1. Install Dependencies
```bash
python setup_scraper.py
```

### 2. Configure Firebase (Optional)
- Download service account key from Firebase Console
- Rename it to `bazarse-service-account.json`
- Place in project root

### 3. Run Scraper
```bash
# Scrape all Ujjain categories
python google_maps_scraper_bazarse.py --ujjain

# Scrape with Firebase upload
python google_maps_scraper_bazarse.py --ujjain --firebase

# Single category search
python google_maps_scraper_bazarse.py -s "restaurants in Ujjain" -t 100
```

## 🎯 **Usage Examples**

### **Complete Ujjain Business Data**
```bash
python google_maps_scraper_bazarse.py --ujjain --firebase -t 50
```
**Result**: Scrapes 30+ categories, ~1500+ businesses

### **Specific Category**
```bash
python google_maps_scraper_bazarse.py -s "medical stores in Ujjain" -t 100
```

### **Custom Queries**
Edit `ujjain_business_queries.txt` and run:
```bash
python google_maps_scraper_bazarse.py -t 50
```

## 📈 **Expected Data Volume**

| Category | Expected Count |
|----------|----------------|
| Restaurants | 200-300 |
| Grocery Stores | 150-200 |
| Medical Stores | 100-150 |
| Clothing Shops | 150-200 |
| Electronics | 100-150 |
| Beauty Parlours | 80-120 |
| **Total Estimated** | **1500-2000+** |

## 🔧 **Command Line Options**

```bash
-s, --search     Single search query
-t, --total      Max results per search (default: 50)
--firebase       Upload to Firebase
--ujjain         Use predefined Ujjain categories
```

## 📁 **Output Structure**

```
Ujjain_Business_Data/
├── 2025-07-04/
│   ├── restaurants.csv
│   ├── restaurants.xlsx
│   ├── grocery_stores.csv
│   ├── grocery_stores.xlsx
│   └── ... (all categories)
```

## 🔥 **Firebase Integration**

**Collections Created:**
- `ujjain_businesses_restaurants`
- `ujjain_businesses_grocery_stores`
- `ujjain_businesses_medical_stores`
- ... (one per category)

**Data Structure:**
```json
{
  "name": "Mahakal Sweets",
  "address": "Near Mahakaleshwar Temple, Ujjain",
  "phone_number": "+91 9876543210",
  "category": "Food & Dining",
  "city": "Ujjain",
  "state": "Madhya Pradesh",
  "reviews_average": 4.5,
  "reviews_count": 150,
  "latitude": 23.1765,
  "longitude": 75.7885,
  "verified": true,
  "source": "google_maps_scraper"
}
```

## ⚡ **Performance & Speed**

**Scraping Speed:**
- ~2-3 businesses per minute
- ~100 businesses in 30-40 minutes
- Complete Ujjain data in 8-12 hours

**Optimization Tips:**
- Use `--headless` for faster scraping
- Reduce `-t` value for quicker tests
- Run overnight for complete data

## 🛡️ **Best Practices**

### **Avoid Getting Blocked:**
- Don't run too frequently (max 1-2 times per day)
- Use reasonable delays between requests
- Don't scrape same queries repeatedly

### **Data Quality:**
- Review extracted data for accuracy
- Remove duplicates manually if needed
- Verify phone numbers and addresses

## 🔍 **Troubleshooting**

### **Common Issues:**

**1. Browser Not Opening**
```bash
playwright install chromium
```

**2. Firebase Connection Error**
- Check service account key path
- Verify Firebase project ID
- Ensure Firestore is enabled

**3. No Results Found**
- Check internet connection
- Verify search query format
- Try different search terms

**4. Slow Performance**
- Close other browser windows
- Use headless mode
- Reduce result count

## 📊 **Data Validation**

**Quality Checks:**
- ✅ Phone numbers in Indian format
- ✅ Addresses contain "Ujjain"
- ✅ Coordinates within Ujjain bounds
- ✅ Business names are meaningful
- ✅ No duplicate entries

## 🚀 **Integration with Bazar Se App**

**Next Steps:**
1. **Import to Firebase** - Use scraped data in your app
2. **Category Mapping** - Map to your 25 categories
3. **Data Enhancement** - Add offers, images, AI features
4. **Verification** - Mark businesses as verified
5. **Live Updates** - Regular scraping for new businesses

## 📞 **Support**

**If you need help:**
- Check the error messages carefully
- Ensure all dependencies are installed
- Verify Firebase configuration
- Test with single search first

---

**🎉 Ready to scrape Ujjain business data for Bazar Se!**

**Estimated Time:** 8-12 hours for complete data  
**Expected Results:** 1500-2000+ real businesses  
**Data Quality:** High (real Google Maps data)**
