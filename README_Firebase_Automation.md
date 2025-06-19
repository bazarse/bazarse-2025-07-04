# 🔥 Firebase Auto-Updater - Vinu Bhaisahab ka Automation System 🔥

**Automatically updates Firebase with new data, manages collections, and keeps everything synced for Bazarse app!**

## 🚀 Features

- **🎬 Auto-Generate Deels**: Creates new deals every 30 minutes
- **🏪 Store Updates**: Updates store metrics hourly  
- **📊 Analytics Generation**: Generates analytics data every 2 hours
- **🔔 Push Notifications**: Sends notifications every 4 hours
- **🧹 Auto Cleanup**: Removes expired data daily
- **📱 Real-time Sync**: Keeps Firebase always updated
- **🔄 Continuous Running**: 24/7 automation

## 📋 Prerequisites

- Python 3.8+
- Firebase Admin SDK access
- Service Account Key from Firebase Console

## ⚡ Quick Setup

### 1. Run Setup Script
```bash
python setup_firebase_automation.py
```

### 2. Download Service Account Key
1. Go to [Firebase Console](https://console.firebase.google.com/project/bazarse-8c768/settings/serviceaccounts/adminsdk)
2. Click "Generate new private key"
3. Save as `bazarse-service-account.json`

### 3. Start Automation
```bash
# Windows
start_automation.bat

# Linux/Mac
./start_automation.sh
```

## 🔧 Manual Setup

### Install Dependencies
```bash
pip install -r requirements.txt
```

### Configure Environment
```bash
cp .env.example .env
# Edit .env with your settings
```

### Run Automation
```bash
python firebase_auto_updater.py
```

## 📊 Automation Schedule

| Task | Frequency | Description |
|------|-----------|-------------|
| **New Deels** | Every 30 minutes | Generates fresh deals for stores |
| **Store Updates** | Every 1 hour | Updates store metrics and ratings |
| **Analytics** | Every 2 hours | Generates usage analytics |
| **Notifications** | Every 4 hours | Sends push notifications |
| **Cleanup** | Daily at 2 AM | Removes expired data |

## 🏪 Auto-Generated Content

### Deels Include:
- Random Ujjain stores
- Realistic offers and discounts
- Video URLs and thumbnails
- Store information and contact
- Expiry dates and stock levels
- Trending flags and categories

### Store Updates:
- View counts and likes
- Ratings and reviews
- Last active timestamps
- Performance metrics

### Analytics Data:
- Daily active users
- Deal interactions
- Category performance
- City-wise statistics

## 🔔 Notification Types

- 🔥 Hot deals alerts
- 💰 Flash sale notifications  
- 🎉 Weekend specials
- 📱 Trending deals
- 🛍️ Personalized offers
- 🌟 Store recommendations

## 🐳 Docker Deployment

### Build and Run
```bash
docker-compose up -d
```

### View Logs
```bash
docker-compose logs -f firebase-auto-updater
```

## 🖥️ System Service (Linux)

### Install as Service
```bash
sudo cp firebase-auto-updater.service /etc/systemd/system/
sudo systemctl enable firebase-auto-updater
sudo systemctl start firebase-auto-updater
```

### Check Status
```bash
sudo systemctl status firebase-auto-updater
```

## 📊 Monitoring

### Check Logs
```bash
tail -f firebase_auto_updater.log
```

### Monitor Status
```bash
python monitor_automation.py
```

## ⚙️ Configuration

### Update Intervals (in minutes)
```python
UPDATE_INTERVALS = {
    'new_deels': 30,        # New deals
    'store_updates': 60,    # Store metrics
    'analytics': 120,       # Analytics data
    'notifications': 240,   # Push notifications
    'cleanup': 1440,        # Daily cleanup
}
```

### Supported Cities
- Ujjain (Primary)
- Indore
- Bhopal  
- Dewas

### Store Categories
- Food & Restaurants
- Electronics & Mobile
- Fashion & Clothing
- Grocery & Supermarket
- Health & Pharmacy
- Books & Stationery
- Home & Furniture
- Beauty & Cosmetics
- Sports & Fitness
- Automotive
- Services

## 🔒 Security Features

- Rate limiting (100 requests/minute)
- API throttling (1000 requests/hour)
- Secure service account authentication
- Error logging and monitoring
- Automatic retry mechanisms

## 📈 Performance

- **Lightweight**: Minimal resource usage
- **Efficient**: Batch operations for better performance
- **Scalable**: Can handle thousands of deals
- **Reliable**: Auto-restart on failures
- **Fast**: Optimized Firebase queries

## 🛠️ Troubleshooting

### Common Issues

1. **Service Account Error**
   ```
   Solution: Ensure bazarse-service-account.json exists and is valid
   ```

2. **Permission Denied**
   ```
   Solution: Check Firebase project permissions
   ```

3. **Network Issues**
   ```
   Solution: Verify internet connection and Firebase status
   ```

### Debug Mode
```bash
python firebase_auto_updater.py --debug
```

## 📞 Support

For issues or questions:
- Check logs: `firebase_auto_updater.log`
- Monitor status: `python monitor_automation.py`
- Review configuration: `firebase_config.py`

## 🎯 Benefits

- **Always Fresh Content**: New deals every 30 minutes
- **Real-time Analytics**: Live performance data
- **User Engagement**: Regular notifications
- **Data Hygiene**: Automatic cleanup
- **Zero Maintenance**: Runs continuously
- **Scalable**: Grows with your business

## 🔥 Result

**Your Firebase will now:**
- ✅ Generate 48 new deals daily
- ✅ Update 240+ store metrics daily  
- ✅ Create 12 analytics reports daily
- ✅ Send 6 notification campaigns daily
- ✅ Maintain clean, optimized data
- ✅ Provide real-time user experience

**Zomato, Swiggy, Blinkit ko takkar dene ke liye ready! 💪🚀**
