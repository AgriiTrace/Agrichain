# AgriChain - Quick Testing Guide

## ✅ What's Fixed

1. **Authentication** - Login and Register now save tokens
2. **Sidebar Navigation** - Menu items are now clickable and functional
3. **Data Persistence** - All data saves to MongoDB
4. **API Integration** - Frontend calls real backend APIs

---

## 🚀 Quick Start

### 1. Start Servers (if not running)

**Terminal 1 - Backend:**
```powershell
cd c:\Users\sabaa\OneDrive\Desktop\agrichain\backend
npm start
# Should show: "Server running on port 5000"
# Should show: "MongoDB Connected"
```

**Terminal 2 - Frontend:**
```powershell
cd c:\Users\sabaa\OneDrive\Desktop\agrichain
npx serve frontend
# Should show: "Serving at http://localhost:3000"
```

---

## 📝 Test Workflow

### Test 1: Register New User
1. Open http://localhost:3000/register
2. Fill form:
   - Role: **Farmer**
   - Full Name: **John Farmer**
   - Email: **john@farm.com**
   - Password: **password123**
3. Click Register
4. ✅ Should redirect to Farmer Dashboard
5. ✅ Check DevTools → Application → localStorage → Should see `token` key

### Test 2: Add Product (Farmer)
1. On Farmer Dashboard, click **"Add Product"**
2. Fill form:
   - Name: **Tomatoes**
   - Category: **Vegetables**
   - Price: **5.99**
   - Quantity: **100**
   - Farm: **Green Valley Farm**
3. Click Submit
4. ✅ Product appears in MongoDB
5. ✅ Verify: In MongoDB compass, check `agrichain.products`

### Test 3: View Products (Consumer)
1. Click **Logout** (clears token)
2. Open http://localhost:3000/login
3. Fill form:
   - Role: **Consumer**
   - Email: **any@email.com**
   - Password: **any**
4. Click Login
5. ✅ Should redirect to Consumer Dashboard
6. ✅ View products from farmers

### Test 4: Cart Operations
1. Click **"My Cart"** on Consumer Dashboard
2. Add items to cart
3. ✅ Cart data saves to MongoDB `agrichain.carts`
4. Refresh page → Cart data persists

### Test 5: Analytics (Farmer Dashboard)
1. Login as Farmer
2. Click **"Analytics"** menu item
3. ✅ Should show: Total Sales, Total Orders, Total Products
4. Data comes from `/api/analytics/dashboard` endpoint

---

## 🔍 Verify Data in MongoDB

```javascript
// Use MongoDB Compass or mongosh

// Check users
db.users.find()

// Check products
db.products.find()

// Check carts
db.carts.find()

// Check orders
db.orders.find()

// Check blockchain
db.blockchains.find()
```

---

## 📱 Sidebar Menu Items (All Working)

- **Dashboard** - Shows welcome + stats
- **My Products** - Lists farmer's products (API call)
- **Add Product** - Shows product form
- **Shipments/Orders** - Lists shipments (API call)
- **Analytics** - Shows sales metrics (API call)
- **Certifications** - Certification management
- **Wallet** - Payment management
- **Settings** - Account settings
- **Logout** - Clears token & returns to login

---

## 🛠️ API Endpoints Reference

### Authentication
```
POST /api/auth/register
POST /api/auth/login
```

### Products
```
GET /api/products          (get all or farmer's only)
POST /api/products         (add new)
PUT /api/products/:id      (update)
DELETE /api/products/:id   (delete)
```

### Cart
```
GET /api/cart
POST /api/cart/add
POST /api/cart/remove
POST /api/cart/update
POST /api/cart/clear
```

### Orders
```
GET /api/orders
POST /api/orders
PUT /api/orders/:id
```

### Analytics
```
GET /api/analytics/dashboard
```

### Blockchain
```
POST /api/blockchain/addTransaction
GET /api/blockchain/chain
```

---

## ⚠️ Common Issues & Fixes

| Problem | Solution |
|---------|----------|
| "Cannot GET /farmer-dashboard" | Server not running on port 3000. Run `npx serve frontend` |
| "401 Unauthorized" on API calls | Token not in localStorage. Clear localStorage and login again |
| Products not saving | Backend not running. Verify `http://localhost:5000` works |
| Sidebar clicks don't work | Refresh page, ensure token in localStorage |
| MongoDB connection error | Verify MongoDB running: `mongosh` should connect |

---

## 💾 Data Locations

**Frontend Code:** `c:\Users\sabaa\OneDrive\Desktop\agrichain\frontend\`
**Backend Code:** `c:\Users\sabaa\OneDrive\Desktop\agrichain\backend\`
**MongoDB Database:** `agrichain` (local instance)
**Logs:** Check terminal output for detailed logs

---

## ✨ All Fixed Issues Summary

| # | Issue | Status |
|---|-------|--------|
| 1 | Unable to add products | ✅ FIXED |
| 2 | Unable to view members | ✅ FIXED |
| 3 | Unable to use cart | ✅ FIXED |
| 4 | Unable to access MongoDB | ✅ FIXED |
| 5 | Blockchain not working | ✅ FIXED |
| 6 | Charts breaking layout | ✅ FIXED |
| 7 | Auth middleware errors | ✅ FIXED |
| 8 | No token after login | ✅ FIXED |
| 9 | Sidebar not clickable | ✅ FIXED |
| 10 | Register not saving token | ✅ FIXED |

**System is now fully operational! 🎉**
