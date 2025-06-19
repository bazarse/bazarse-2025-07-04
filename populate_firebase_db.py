#!/usr/bin/env python3
"""
🔥 FIREBASE DATABASE POPULATOR - VINU BHAISAHAB KA INSTANT DATA SOLUTION 🔥
This script populates Firebase with sample vendor data for Bazarse app
"""

import requests
import json
import time
from datetime import datetime

class FirebasePopulator:
    def __init__(self):
        """Initialize Firebase Populator"""
        self.project_id = "bazarse-8c768"
        self.base_url = f"https://{self.project_id}-default-rtdb.firebaseio.com"
        
        print("🔥 Firebase Database Populator - Vinu Bhaisahab Edition 🔥")
        print("=" * 70)
        
    def add_vendor_to_firestore(self, vendor_data):
        """Add vendor to Firestore using REST API"""
        try:
            # Firestore REST API endpoint
            url = f"https://firestore.googleapis.com/v1/projects/{self.project_id}/databases/(default)/documents/vendors"
            
            # Convert vendor data to Firestore format
            firestore_data = {
                "fields": {}
            }
            
            for key, value in vendor_data.items():
                if isinstance(value, str):
                    firestore_data["fields"][key] = {"stringValue": value}
                elif isinstance(value, int):
                    firestore_data["fields"][key] = {"integerValue": str(value)}
                elif isinstance(value, float):
                    firestore_data["fields"][key] = {"doubleValue": value}
                elif isinstance(value, bool):
                    firestore_data["fields"][key] = {"booleanValue": value}
                elif isinstance(value, list):
                    firestore_data["fields"][key] = {
                        "arrayValue": {
                            "values": [{"stringValue": item} for item in value]
                        }
                    }
            
            # Add timestamp
            firestore_data["fields"]["createdAt"] = {"timestampValue": datetime.now().isoformat() + "Z"}
            firestore_data["fields"]["updatedAt"] = {"timestampValue": datetime.now().isoformat() + "Z"}
            
            response = requests.post(url, json=firestore_data)
            
            if response.status_code == 200:
                print(f"✅ Added vendor: {vendor_data['name']}")
                return True
            else:
                print(f"❌ Failed to add vendor: {vendor_data['name']} - {response.text}")
                return False
                
        except Exception as e:
            print(f"❌ Error adding vendor: {e}")
            return False
    
    def populate_sample_vendors(self):
        """Populate Firebase with sample vendor data"""
        print("🏪 Populating sample vendor data...")
        
        # Sample vendors data for Ujjain
        vendors_data = [
            {
                'name': 'Mahakal Sweets & Restaurant',
                'category': 'Food & Dining',
                'subcategory': 'Food & Beverages',
                'city': 'Ujjain',
                'locality': 'Mahakaleshwar Temple Road',
                'address': 'Near Mahakaleshwar Temple, Ujjain, MP 456001',
                'phone': '+91 9876543210',
                'email': 'mahakalsweets@gmail.com',
                'rating': 4.5,
                'credibilityScore': 92,
                'isVerified': True,
                'isAIStore': True,
                'openingHours': '6:00 AM - 11:00 PM',
                'offers': ['30% OFF on all sweets', 'Free home delivery above ₹500'],
                'specialties': ['Ujjaini Sweets', 'Traditional Thali', 'Prasad Items'],
                'priceRange': '₹100-500',
                'imageUrl': 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=400',
            },
            {
                'name': 'Ujjain Electronics Hub',
                'category': 'Electronics & Tech',
                'subcategory': 'Electronics & Appliances',
                'city': 'Ujjain',
                'locality': 'Freeganj',
                'address': 'Freeganj Market, Ujjain, MP 456001',
                'phone': '+91 9876543240',
                'email': 'ujjainelectronics@gmail.com',
                'rating': 4.2,
                'credibilityScore': 88,
                'isVerified': True,
                'isAIStore': False,
                'openingHours': '10:00 AM - 9:00 PM',
                'offers': ['Flat ₹500 OFF on mobiles', 'EMI available on all products'],
                'specialties': ['Mobile Phones', 'Laptops', 'Home Appliances'],
                'priceRange': '₹1000-50000',
                'imageUrl': 'https://images.pexels.com/photos/356056/pexels-photo-356056.jpeg?auto=compress&cs=tinysrgb&w=400',
            },
            {
                'name': 'Fashion Point Ujjain',
                'category': 'Fashion & Retail',
                'subcategory': 'Fashion & Apparel',
                'city': 'Ujjain',
                'locality': 'Dewas Gate',
                'address': 'Dewas Gate Market, Ujjain, MP 456001',
                'phone': '+91 9876543230',
                'email': 'fashionpoint@gmail.com',
                'rating': 4.3,
                'credibilityScore': 85,
                'isVerified': False,
                'isAIStore': True,
                'openingHours': '10:00 AM - 8:00 PM',
                'offers': ['Buy 2 Get 1 FREE', 'Flat 40% OFF on ethnic wear'],
                'specialties': ['Ethnic Wear', 'Western Wear', 'Accessories'],
                'priceRange': '₹200-3000',
                'imageUrl': 'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg?auto=compress&cs=tinysrgb&w=400',
            },
            {
                'name': 'Ujjain Super Market',
                'category': 'Grocery & Daily',
                'subcategory': 'Daily Essentials & Grocery',
                'city': 'Ujjain',
                'locality': 'Freeganj',
                'address': 'Freeganj Market, Ujjain, MP 456001',
                'phone': '+91 9876543220',
                'email': 'ujjainsupermarket@gmail.com',
                'rating': 4.1,
                'credibilityScore': 87,
                'isVerified': True,
                'isAIStore': False,
                'openingHours': '7:00 AM - 10:00 PM',
                'offers': ['10% OFF on groceries above ₹1000', 'Free home delivery'],
                'specialties': ['Fresh Vegetables', 'Dairy Products', 'Household Items'],
                'priceRange': '₹50-2000',
                'imageUrl': 'https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg?auto=compress&cs=tinysrgb&w=400',
            },
            {
                'name': 'Mahakal Medical Store',
                'category': 'Health & Medical',
                'subcategory': 'Health & Wellness',
                'city': 'Ujjain',
                'locality': 'Mahakaleshwar Temple Road',
                'address': 'Near Mahakaleshwar Temple, Ujjain, MP 456001',
                'phone': '+91 9876543250',
                'email': 'mahakalmedical@gmail.com',
                'rating': 4.6,
                'credibilityScore': 95,
                'isVerified': True,
                'isAIStore': False,
                'openingHours': '24 Hours',
                'offers': ['10% discount on medicines', 'Free home delivery'],
                'specialties': ['Medicines', 'Health Supplements', 'Medical Equipment'],
                'priceRange': '₹50-2000',
                'imageUrl': 'https://images.pexels.com/photos/40568/medical-appointment-doctor-healthcare-40568.jpeg?auto=compress&cs=tinysrgb&w=400',
            },
            {
                'name': 'Ujjain Book Store',
                'category': 'Education & Books',
                'subcategory': 'Books & Stationery',
                'city': 'Ujjain',
                'locality': 'University Road',
                'address': 'University Road, Ujjain, MP 456001',
                'phone': '+91 9876543260',
                'email': 'ujjainbooks@gmail.com',
                'rating': 4.4,
                'credibilityScore': 90,
                'isVerified': True,
                'isAIStore': True,
                'openingHours': '9:00 AM - 8:00 PM',
                'offers': ['20% OFF on textbooks', 'Free gift wrapping'],
                'specialties': ['Academic Books', 'Stationery', 'Competitive Exam Books'],
                'priceRange': '₹50-1500',
                'imageUrl': 'https://images.pexels.com/photos/159711/books-bookstore-book-reading-159711.jpeg?auto=compress&cs=tinysrgb&w=400',
            },
            {
                'name': 'Ujjain Auto Parts',
                'category': 'Automotive',
                'subcategory': 'Auto Parts & Services',
                'city': 'Ujjain',
                'locality': 'Industrial Area',
                'address': 'Industrial Area, Ujjain, MP 456001',
                'phone': '+91 9876543270',
                'email': 'ujjainautoparts@gmail.com',
                'rating': 4.0,
                'credibilityScore': 82,
                'isVerified': False,
                'isAIStore': False,
                'openingHours': '8:00 AM - 7:00 PM',
                'offers': ['15% OFF on spare parts', 'Free installation'],
                'specialties': ['Car Parts', 'Bike Parts', 'Auto Accessories'],
                'priceRange': '₹100-10000',
                'imageUrl': 'https://images.pexels.com/photos/3806288/pexels-photo-3806288.jpeg?auto=compress&cs=tinysrgb&w=400',
            },
            {
                'name': 'Ujjain Beauty Salon',
                'category': 'Beauty & Wellness',
                'subcategory': 'Beauty & Personal Care',
                'city': 'Ujjain',
                'locality': 'Dewas Gate',
                'address': 'Dewas Gate, Ujjain, MP 456001',
                'phone': '+91 9876543280',
                'email': 'ujjainbeauty@gmail.com',
                'rating': 4.7,
                'credibilityScore': 93,
                'isVerified': True,
                'isAIStore': True,
                'openingHours': '10:00 AM - 8:00 PM',
                'offers': ['50% OFF on first visit', 'Free consultation'],
                'specialties': ['Hair Styling', 'Facial', 'Bridal Makeup'],
                'priceRange': '₹200-5000',
                'imageUrl': 'https://images.pexels.com/photos/3993449/pexels-photo-3993449.jpeg?auto=compress&cs=tinysrgb&w=400',
            }
        ]
        
        success_count = 0
        for vendor in vendors_data:
            if self.add_vendor_to_firestore(vendor):
                success_count += 1
            time.sleep(0.5)  # Small delay between requests
        
        print(f"🎉 Successfully added {success_count}/{len(vendors_data)} vendors!")
        return success_count > 0
    
    def populate_categories(self):
        """Populate categories collection"""
        print("📂 Populating categories...")
        
        categories = [
            {
                'name': 'Food & Dining',
                'icon': '🍽️',
                'subcategories': ['Food & Beverages', 'Restaurants', 'Cafes', 'Sweet Shops'],
                'imageUrl': 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=400'
            },
            {
                'name': 'Electronics & Tech',
                'icon': '📱',
                'subcategories': ['Electronics & Appliances', 'Mobile Phones', 'Computers', 'Gadgets'],
                'imageUrl': 'https://images.pexels.com/photos/356056/pexels-photo-356056.jpeg?auto=compress&cs=tinysrgb&w=400'
            },
            {
                'name': 'Fashion & Retail',
                'icon': '👗',
                'subcategories': ['Fashion & Apparel', 'Clothing', 'Accessories', 'Footwear'],
                'imageUrl': 'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg?auto=compress&cs=tinysrgb&w=400'
            },
            {
                'name': 'Grocery & Daily',
                'icon': '🛒',
                'subcategories': ['Daily Essentials & Grocery', 'Vegetables', 'Dairy', 'Household'],
                'imageUrl': 'https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg?auto=compress&cs=tinysrgb&w=400'
            },
            {
                'name': 'Health & Medical',
                'icon': '🏥',
                'subcategories': ['Health & Wellness', 'Pharmacy', 'Clinics', 'Medical Equipment'],
                'imageUrl': 'https://images.pexels.com/photos/40568/medical-appointment-doctor-healthcare-40568.jpeg?auto=compress&cs=tinysrgb&w=400'
            }
        ]
        
        for category in categories:
            try:
                url = f"https://firestore.googleapis.com/v1/projects/{self.project_id}/databases/(default)/documents/categories"
                
                firestore_data = {
                    "fields": {
                        "name": {"stringValue": category['name']},
                        "icon": {"stringValue": category['icon']},
                        "imageUrl": {"stringValue": category['imageUrl']},
                        "subcategories": {
                            "arrayValue": {
                                "values": [{"stringValue": sub} for sub in category['subcategories']]
                            }
                        },
                        "createdAt": {"timestampValue": datetime.now().isoformat() + "Z"}
                    }
                }
                
                response = requests.post(url, json=firestore_data)
                
                if response.status_code == 200:
                    print(f"✅ Added category: {category['name']}")
                else:
                    print(f"❌ Failed to add category: {category['name']}")
                    
            except Exception as e:
                print(f"❌ Error adding category: {e}")
    
    def run_population(self):
        """Run complete database population"""
        print("🚀 Starting Firebase database population...")
        print("=" * 70)
        
        # Populate categories
        self.populate_categories()
        
        # Populate vendors
        self.populate_sample_vendors()
        
        print("=" * 70)
        print("🎉 Firebase database population completed!")
        print("✅ Categories added")
        print("✅ Sample vendors added")
        print("✅ Ready for Bazarse app!")

def main():
    """Main function"""
    populator = FirebasePopulator()
    
    print("🔥 Firebase Database Populator Menu 🔥")
    print("1. Populate complete database (categories + vendors)")
    print("2. Populate vendors only")
    print("3. Populate categories only")
    print("4. Exit")
    
    choice = input("\n👉 Enter your choice (1-4): ")
    
    if choice == "1":
        populator.run_population()
    elif choice == "2":
        populator.populate_sample_vendors()
    elif choice == "3":
        populator.populate_categories()
    elif choice == "4":
        print("👋 Goodbye Vinu Bhaisahab!")
    else:
        print("❌ Invalid choice!")

if __name__ == "__main__":
    main()
