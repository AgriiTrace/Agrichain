## AgriChain - Complete Setup & Test Guide

### ✅ What's Fixed

**Backend Issues Resolved:**
1. ✓ **Auth imports** - Fixed `auth` middleware imports in all routes (products, orders, notifications, analytics, blockchain)
2. ✓ **Blockchain import** - Destructured `Blockchain` class from module export
3. ✓ **Blockchain methods** - Added `getChain()` and `getProduct()` helpers, fixed `addTransaction()` to return block with hash
4. ✓ **Product creation** - Accepts lightweight JSON, auto-fills required nested fields (farm, origin, images, etc.)
5. ✓ **Analytics endpoint** - `/api/analytics/dashboard` exists with revenue/order history and category breakdown
6. ✓ **Cart feature** - New `/api/cart` routes: GET, POST /add, POST /remove, POST /update, POST /clear
7. ✓ **Members view** - New `/api/members` routes: GET all, filter by role, search by name/email
8. ✓ **Server running** - Port 5000, MongoDB connected

**Frontend Improvements:**
1. ✓ **Product form** - Form fields now have `name` attributes matching backend expectations
2. ✓ **Product submission** - `submitAddProduct()` sends JSON to `/api/products` with token auth
3. ✓ **Chart sizing** - Fixed analytics charts from expanding to full page (height: 300px)

---

### 🚀 Quick Start

#### 1. Start Backend
```powershell
cd C:\Users\sabaa\OneDrive\Desktop\agrichain\backend
npm start
```
Expected output:
```
Server running on port 5000
Environment: development
Connected to MongoDB
```

#### 2. Verify MongoDB Connection
- Make sure MongoDB is running locally (default: `mongodb://localhost:27017/agrichain`)
- Or set `MONGODB_URI` environment variable:
  ```powershell
  $env:MONGODB_URI = "mongodb+srv://user:password@cluster.mongodb.net/agrichain"
  npm start
  ```

#### 3. Start Frontend
Open `farmer-dashboard.html` in browser OR serve it:
```powershell
cd C:\Users\sabaa\OneDrive\Desktop\agrichain
npx serve frontend
# Then visit http://localhost:3000/farmer-dashboard.html
```

---

### 📝 API Endpoints & Tests

#### **Authentication**
```bash
# Register new farmer
POST http://localhost:5000/api/auth/register
Content-Type: application/json

{
  "username": "farmer1",
  "email": "farmer@example.com",
  "password": "password123",
  "role": "farmer"
}

# Response includes token and user info
```

#### **Products** (requires Bearer token in Authorization header)
```bash
# Create product
POST http://localhost:5000/api/products
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Fresh Tomatoes",
  "category": "vegetables",
  "pricePerUnit": 3.50,
  "availableQuantity": 100,
  "harvestDate": "2025-11-15",
  "description": "Organic fresh tomatoes",
  "farmName": "My Farm"
}

# Get all products
GET http://localhost:5000/api/products

# Get product by ID
GET http://localhost:5000/api/products/{productId}
```

#### **Cart**
```bash
# Get user cart
GET http://localhost:5000/api/cart
Authorization: Bearer <token>

# Add item to cart
POST http://localhost:5000/api/cart/add
Authorization: Bearer <token>
Content-Type: application/json

{
  "productId": "{productId}",
  "quantity": 5
}

# Remove item
POST http://localhost:5000/api/cart/remove
Authorization: Bearer <token>
{"productId": "{productId}"}

# Update quantity
POST http://localhost:5000/api/cart/update
Authorization: Bearer <token>
{"productId": "{productId}", "quantity": 10}

# Clear cart
POST http://localhost:5000/api/cart/clear
Authorization: Bearer <token>
```

#### **Members/Users**
```bash
# Get all users
GET http://localhost:5000/api/members

# Get all farmers
GET http://localhost:5000/api/members/role/farmers

# Get all retailers
GET http://localhost:5000/api/members/role/retailers

# Search by name/email
GET http://localhost:5000/api/members?search=john

# Filter by role
GET http://localhost:5000/api/members?role=farmer

# Get specific member
GET http://localhost:5000/api/members/{userId}
```

#### **Analytics**
```bash
# Dashboard analytics (requires auth)
GET http://localhost:5000/api/analytics/dashboard
Authorization: Bearer <token>

# Product analytics
GET http://localhost:5000/api/analytics/products/{productId}
Authorization: Bearer <token>
```

#### **Orders**
```bash
# Get user orders
GET http://localhost:5000/api/orders
Authorization: Bearer <token>

# Create order
POST http://localhost:5000/api/orders
Authorization: Bearer <token>
Content-Type: application/json

{
  "productId": "{productId}",
  "quantity": 5,
  "shippingAddress": {
    "address": "123 Main St",
    "city": "Springfield",
    "state": "IL",
    "zipCode": "62701",
    "country": "USA"
  }
}

# Update order status
PUT http://localhost:5000/api/orders/{orderId}/status
Authorization: Bearer <token>
Content-Type: application/json

{
  "status": "confirmed"  # or shipped, delivered, cancelled
}
```

#### **Blockchain**
```bash
# Get blockchain
GET http://localhost:5000/api/blockchain

# Get transaction history for product
GET http://localhost:5000/api/blockchain/transactions/{productId}
```

---

### 🧪 Manual Testing Steps

**Step 1: Register User**
1. Open Postman or curl
2. POST to `http://localhost:5000/api/auth/register`
3. Body:
   ```json
   {
     "username": "testfarmer",
     "email": "test@farm.com",
     "password": "test123",
     "role": "farmer"
   }
   ```
4. Copy the `token` from response

**Step 2: Add Product (in MongoDB)**
1. POST to `http://localhost:5000/api/products`
2. Add header: `Authorization: Bearer {token}`
3. Body:
   ```json
   {
     "name": "Organic Apples",
     "category": "fruits",
     "pricePerUnit": 4.99,
     "availableQuantity": 500,
     "harvestDate": "2025-11-10",
     "description": "Fresh red apples from our orchard",
     "farmName": "Green Valley Farm"
   }
   ```
4. **Check MongoDB:** Open MongoDB compass/mongosh
   ```javascript
   use agrichain
   db.products.findOne()
   ```
   You should see the product document with all nested fields populated.

**Step 3: Add to Cart**
1. POST to `http://localhost:5000/api/cart/add`
2. Add header: `Authorization: Bearer {token}`
3. Body:
   ```json
   {
     "productId": "{productIdFromStep2}",
     "quantity": 10
   }
   ```
4. **Check MongoDB:**
   ```javascript
   db.carts.findOne({buyer: ObjectId("{userId}")})
   ```

**Step 4: Create Order**
1. POST to `http://localhost:5000/api/orders`
2. Add header: `Authorization: Bearer {token}`
3. Body:
   ```json
   {
     "productId": "{productId}",
     "quantity": 5,
     "shippingAddress": {
       "address": "456 Farm Road",
       "city": "Rural",
       "state": "IA",
       "zipCode": "50001",
       "country": "USA"
     }
   }
   ```
4. **Check MongoDB:**
   ```javascript
   db.orders.findOne()
   ```

**Step 5: View Analytics**
1. GET to `http://localhost:5000/api/analytics/dashboard`
2. Add header: `Authorization: Bearer {token}`
3. Should see revenue history, order data, category breakdown

---

### 🔧 Troubleshooting

**Issue: Port 5000 already in use**
```powershell
# Find and kill process using port 5000
Get-Process | Where-Object {$_.Name -eq "node"} | Stop-Process -Force
npm start
```

**Issue: MongoDB connection failed**
- Verify MongoDB is running: `mongosh` or check MongoDB Compass
- Set environment variable if using cloud:
  ```powershell
  $env:MONGODB_URI = "your_connection_string"
  npm start
  ```

**Issue: Product not saving to MongoDB**
- Check auth token is valid: `GET /api/health` should return `{ status: "OK" }`
- Ensure Bearer token is included in Authorization header
- Check MongoDB logs for validation errors

**Issue: Charts not showing**
- Open browser dev console (F12)
- Check for CORS errors - ensure frontend URL matches `FRONTEND_URL` env variable
- Verify Chart.js library is loaded: check Network tab

---

### 📂 Files Modified/Created

**Modified:**
- `backend/routes/products.js` - Lightweight product creation with defaults
- `backend/routes/auth.js` - Fixed auth middleware import
- `backend/routes/orders.js` - Fixed auth middleware import
- `backend/routes/notifications.js` - Fixed auth middleware import
- `backend/routes/analytics.js` - Fixed auth middleware import
- `backend/routes/blockchain.js` - Fixed auth middleware import
- `backend/blockchain/blockchain.js` - Added helpers, fixed return values
- `backend/server.js` - Added cart, analytics, members routes; fixed imports
- `frontend/farmer-dashboard.html` - Added form names, `submitAddProduct()`, chart CSS

**Created:**
- `backend/models/Cart.js` - Cart schema
- `backend/routes/cart.js` - Cart endpoints
- `backend/routes/members.js` - Members/users endpoints

---

### 🎯 What You Can Do Now

✅ **Register users** (farmer, retailer, consumer, admin)
✅ **Add products** to database with metadata
✅ **View all products** with filtering
✅ **Add/remove items from cart**
✅ **View cart total**
✅ **Create orders** from products
✅ **Update order status** (pending → confirmed → shipped → delivered)
✅ **View analytics** (revenue, orders, category breakdown)
✅ **Search/filter users** by role
✅ **Track blockchain** transactions for products
✅ **Access all data** from MongoDB

---

### 📊 MongoDB Collections Created

- `users` - Farmers, retailers, consumers, admins
- `products` - Farm products with metadata, pricing, images
- `orders` - Customer orders linking buyers, sellers, products
- `carts` - Shopping carts per user
- `notifications` - System/order notifications
- `blockchain` - Transaction blocks (auto-generated)

---

### 🔐 Next Steps

1. **Test from Frontend Dashboard** - Use the Add Product modal to create products
2. **Implement Image Upload** - Add multer to handle product images
3. **Real-time Updates** - WebSocket integration for live order tracking
4. **Admin Dashboard** - Add admin-specific views and controls
5. **Search & Filters** - Implement advanced product search
6. **Reviews & Ratings** - Enable customer reviews on products
7. **Wallet Integration** - Payment gateway for orders

---

**Status:** ✅ Backend fully operational. All CRUD operations working. MongoDB integrating properly. Ready for frontend integration testing.
