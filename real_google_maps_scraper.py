#!/usr/bin/env python3
"""
🔥 REAL GOOGLE MAPS SCRAPER - ACTUAL UJJAIN DATA 🔥
No mock data - Only real businesses from Google Maps
"""

import requests
import json
import time
import random
from datetime import datetime
import os

class RealGoogleMapsScraper:
    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        })
        self.results_dir = f"Real_Ujjain_Data_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        os.makedirs(self.results_dir, exist_ok=True)
        
    def get_real_ujjain_queries(self):
        """Real search queries for Ujjain businesses"""
        return [
            "restaurants in Ujjain",
            "hotels in Ujjain", 
            "hospitals in Ujjain",
            "medical stores in Ujjain",
            "grocery stores in Ujjain",
            "clothing shops in Ujjain",
            "mobile shops in Ujjain",
            "banks in Ujjain",
            "petrol pumps in Ujjain",
            "schools in Ujjain",
            "colleges in Ujjain",
            "beauty parlors in Ujjain",
            "electronics stores in Ujjain",
            "furniture shops in Ujjain",
            "jewellery shops in Ujjain",
            "sweet shops in Ujjain",
            "bakeries in Ujjain",
            "auto repair in Ujjain",
            "pharmacies in Ujjain",
            "coaching centers in Ujjain",
            "temples in Ujjain",
            "atm in Ujjain",
            "taxi services in Ujjain",
            "real estate in Ujjain",
            "insurance in Ujjain"
        ]
    
    def search_google_maps_api(self, query):
        """Search using Google Places API for real data"""
        
        # Using Google Places Text Search API
        api_key = "AIzaSyAsWs15Tu7mWDxw6bGV5F8LL9FRvztQ_cc"  # Your existing key
        
        url = "https://maps.googleapis.com/maps/api/place/textsearch/json"
        
        params = {
            'query': query,
            'key': api_key,
            'location': '23.1765,75.7885',  # Ujjain coordinates
            'radius': 10000,  # 10km radius
            'language': 'en'
        }
        
        try:
            print(f"🔍 Searching: {query}")
            response = self.session.get(url, params=params)
            
            if response.status_code == 200:
                data = response.json()
                
                if data['status'] == 'OK':
                    businesses = []
                    
                    for place in data.get('results', []):
                        business = self.extract_place_details(place, api_key)
                        if business:
                            businesses.append(business)
                    
                    print(f"✅ Found {len(businesses)} real businesses for: {query}")
                    return businesses
                else:
                    print(f"❌ API Error: {data.get('status')}")
                    return []
            else:
                print(f"❌ HTTP Error: {response.status_code}")
                return []
                
        except Exception as e:
            print(f"❌ Error searching {query}: {e}")
            return []
    
    def extract_place_details(self, place, api_key):
        """Extract detailed information for a place"""
        
        try:
            business = {
                'name': place.get('name'),
                'address': place.get('formatted_address'),
                'place_id': place.get('place_id'),
                'rating': place.get('rating'),
                'user_ratings_total': place.get('user_ratings_total'),
                'price_level': place.get('price_level'),
                'types': place.get('types', []),
                'business_status': place.get('business_status'),
                'permanently_closed': place.get('permanently_closed', False)
            }
            
            # Get coordinates
            if 'geometry' in place and 'location' in place['geometry']:
                location = place['geometry']['location']
                business['latitude'] = location.get('lat')
                business['longitude'] = location.get('lng')
            
            # Get photos
            if 'photos' in place and place['photos']:
                photo_ref = place['photos'][0].get('photo_reference')
                if photo_ref:
                    business['image_url'] = f"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference={photo_ref}&key={api_key}"
            
            # Get more details using Place Details API
            details = self.get_place_details(place.get('place_id'), api_key)
            if details:
                business.update(details)
            
            # Add metadata
            business['scraped_at'] = datetime.now().isoformat()
            business['source'] = 'google_maps_api'
            business['data_type'] = 'real'
            
            return business
            
        except Exception as e:
            print(f"❌ Error extracting place details: {e}")
            return None
    
    def get_place_details(self, place_id, api_key):
        """Get detailed information using Place Details API"""
        
        if not place_id:
            return {}
        
        url = "https://maps.googleapis.com/maps/api/place/details/json"
        
        params = {
            'place_id': place_id,
            'fields': 'name,formatted_address,formatted_phone_number,website,opening_hours,reviews,photos',
            'key': api_key
        }
        
        try:
            response = self.session.get(url, params=params)
            
            if response.status_code == 200:
                data = response.json()
                
                if data['status'] == 'OK' and 'result' in data:
                    result = data['result']
                    
                    details = {}
                    
                    # Phone number
                    if 'formatted_phone_number' in result:
                        details['phone_number'] = result['formatted_phone_number']
                    
                    # Website
                    if 'website' in result:
                        details['website'] = result['website']
                    
                    # Opening hours
                    if 'opening_hours' in result and 'weekday_text' in result['opening_hours']:
                        details['opening_hours'] = result['opening_hours']['weekday_text']
                    
                    # Reviews
                    if 'reviews' in result:
                        details['reviews'] = result['reviews'][:3]  # First 3 reviews
                    
                    return details
            
            return {}
            
        except Exception as e:
            print(f"❌ Error getting place details: {e}")
            return {}
    
    def scrape_all_real_data(self):
        """Scrape all real Ujjain business data"""
        
        print("🔥 REAL GOOGLE MAPS SCRAPER STARTING 🔥")
        print("🎯 EXTRACTING ACTUAL UJJAIN BUSINESSES")
        print("=" * 60)
        
        queries = self.get_real_ujjain_queries()
        all_businesses = []
        
        for i, query in enumerate(queries):
            print(f"\n📍 {i+1}/{len(queries)}: {query}")
            
            businesses = self.search_google_maps_api(query)
            
            if businesses:
                # Save individual query results
                safe_query = query.replace(' ', '_').replace('in_Ujjain', '')
                filename = f"real_{safe_query}.json"
                filepath = os.path.join(self.results_dir, filename)
                
                with open(filepath, 'w') as f:
                    json.dump(businesses, f, indent=2, ensure_ascii=False)
                
                all_businesses.extend(businesses)
                print(f"💾 Saved {len(businesses)} businesses to {filename}")
            
            # Delay to avoid rate limiting
            time.sleep(2)
        
        # Remove duplicates based on place_id
        unique_businesses = []
        seen_place_ids = set()
        
        for business in all_businesses:
            place_id = business.get('place_id')
            if place_id and place_id not in seen_place_ids:
                unique_businesses.append(business)
                seen_place_ids.add(place_id)
        
        # Save complete dataset
        complete_file = os.path.join(self.results_dir, 'complete_real_ujjain_businesses.json')
        with open(complete_file, 'w') as f:
            json.dump(unique_businesses, f, indent=2, ensure_ascii=False)
        
        # Generate summary
        summary = {
            'total_businesses': len(unique_businesses),
            'total_queries': len(queries),
            'extraction_date': datetime.now().isoformat(),
            'data_source': 'Google Maps API',
            'data_type': 'Real business data',
            'location': 'Ujjain, Madhya Pradesh',
            'with_phone': sum(1 for b in unique_businesses if b.get('phone_number')),
            'with_website': sum(1 for b in unique_businesses if b.get('website')),
            'with_images': sum(1 for b in unique_businesses if b.get('image_url')),
            'with_coordinates': sum(1 for b in unique_businesses if b.get('latitude')),
            'with_ratings': sum(1 for b in unique_businesses if b.get('rating'))
        }
        
        summary_file = os.path.join(self.results_dir, 'real_data_summary.json')
        with open(summary_file, 'w') as f:
            json.dump(summary, f, indent=2)
        
        print(f"\n🎉 REAL DATA EXTRACTION COMPLETED!")
        print(f"📊 Total Real Businesses: {len(unique_businesses)}")
        print(f"📞 With Phone Numbers: {summary['with_phone']}")
        print(f"🌐 With Websites: {summary['with_website']}")
        print(f"🖼️ With Images: {summary['with_images']}")
        print(f"📍 With Coordinates: {summary['with_coordinates']}")
        print(f"⭐ With Ratings: {summary['with_ratings']}")
        print(f"📁 Saved in: {self.results_dir}")
        
        return unique_businesses, self.results_dir

def main():
    """Main function to start real data extraction"""
    
    print("🔥 REAL GOOGLE MAPS SCRAPER FOR UJJAIN 🔥")
    print("🚫 NO MOCK DATA - ONLY REAL BUSINESSES")
    print("=" * 60)
    
    scraper = RealGoogleMapsScraper()
    businesses, results_dir = scraper.scrape_all_real_data()
    
    print(f"\n🎯 REAL UJJAIN BUSINESS DATA READY!")
    print(f"📁 Location: {results_dir}")
    print(f"📊 Total: {len(businesses)} REAL businesses")
    print(f"🔥 100% AUTHENTIC Google Maps data")
    print(f"✅ Real names, addresses, phone numbers")
    print(f"✅ Actual GPS coordinates")
    print(f"✅ Real business photos")
    print(f"✅ Genuine ratings and reviews")
    
    return results_dir

if __name__ == "__main__":
    main()
