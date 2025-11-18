# Code Changes Reference

## Key Code Modifications

### 1. Login Authentication (frontend/login.html)

**Location:** Form submit event handler

**NEW CODE:**
```javascript
loginForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const role = userRoleInput.value;
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    
    if (!role) {
        showAlert('Please select your role', 'warning');
        return;
    }
    
    try {
        // Call backend API
        const response = await fetch('http://localhost:5000/api/auth/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, password })
        });
        
        const data = await response.json();
        
        if (response.ok && data.data && data.data.token) {
            // Save token and user info
            localStorage.setItem('token', data.data.token);
            localStorage.setItem('user', JSON.stringify({
                ...data.data.user,
                role: role,
                _id: data.data.user.id || data.data.user._id
            }));
            
            showAlert('Login successful! Redirecting...', 'success');
            
            // Redirect based on role
            setTimeout(() => {
                const dashboardMap = {
                    'farmer': 'farmer-dashboard.html',
                    'retailer': 'retailer-dashboard.html',
                    'consumer': 'consumer-dashboard.html',
                    'admin': 'admin-dashboard.html'
                };
                
                window.location.href = dashboardMap[role];
            }, 1500);
        } else {
            showAlert(data.message || 'Invalid credentials', 'danger');
        }
    } catch (error) {
        console.error('Login error:', error);
        showAlert('Connection error. Make sure backend is running', 'danger');
    }
});
```

---

### 2. Registration Authentication (frontend/register.html)

**Location:** Form submit event handler

**NEW CODE:**
```javascript
registerForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    // Get form data
    const role = selectedRoleInput.value;
    const fullName = document.getElementById('fullName').value;
    const email = document.getElementById('email').value;
    const phone = document.getElementById('phone').value;
    const address = document.getElementById('address').value;
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const farmName = document.getElementById('farmName') ? document.getElementById('farmName').value : '';
    const licenseNumber = document.getElementById('licenseNumber') ? document.getElementById('licenseNumber').value : '';
    
    // Validate
    if (password !== confirmPassword) {
        showAlert('Passwords do not match', 'warning');
        return;
    }
    
    if (!document.getElementById('terms').checked) {
        showAlert('Please accept the terms and conditions', 'warning');
        return;
    }
    
    try {
        // Call backend API
        const response = await fetch('http://localhost:5000/api/auth/register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                fullName, email, phone, address, password, role, farmName, licenseNumber
            })
        });
        
        const data = await response.json();
        
        if (response.ok && data.data && data.data.token) {
            // Save token and user info
            localStorage.setItem('token', data.data.token);
            localStorage.setItem('user', JSON.stringify({
                ...data.data.user,
                role: role,
                _id: data.data.user.id || data.data.user._id
            }));
            
            showAlert('Registration successful! Redirecting to dashboard...', 'success');
            
            setTimeout(() => {
                const dashboardMap = {
                    'farmer': 'farmer-dashboard.html',
                    'retailer': 'retailer-dashboard.html',
                    'consumer': 'consumer-dashboard.html',
                    'admin': 'admin-dashboard.html'
                };
                
                window.location.href = dashboardMap[role];
            }, 1500);
        } else {
            showAlert(data.message || 'Registration failed', 'danger');
        }
    } catch (error) {
        console.error('Registration error:', error);
        showAlert('Connection error. Make sure backend is running', 'danger');
    }
});
```

---

### 3. Sidebar Navigation (frontend/farmer-dashboard.html)

**Location:** Menu item event listeners

**NEW CODE:**
```javascript
document.querySelectorAll('.menu-item').forEach(item => {
    item.addEventListener('click', function(e) {
        const href = this.getAttribute('href');
        
        // Allow logout to work normally
        if (href === 'login.html') {
            localStorage.removeItem('token');
            localStorage.removeItem('user');
            return;
        }
        
        if (href === '#') {
            e.preventDefault();
            
            // Get menu text
            const menuText = this.textContent.trim();
            
            // Remove active class from all items
            document.querySelectorAll('.menu-item').forEach(i => i.classList.remove('active'));
            
            // Add active class to clicked item
            this.classList.add('active');
            
            // Handle menu navigation
            const dashboardContent = document.querySelector('.dashboard-content');
            
            switch(menuText) {
                case 'Dashboard':
                    // Show main dashboard
                    location.hash = '#dashboard';
                    break;
                case 'My Products':
                    location.hash = '#products';
                    dashboardContent.innerHTML = `
                        <h2>My Products</h2>
                        <p>View your listed products here</p>
                        <div id="productsContainer"></div>
                    `;
                    loadUserProducts();
                    break;
                case 'Add Product':
                    location.hash = '#add-product';
                    const formSection = document.querySelector('.add-product-form, form');
                    if (formSection) {
                        formSection.scrollIntoView({ behavior: 'smooth' });
                    }
                    break;
                case 'Shipments':
                    location.hash = '#shipments';
                    dashboardContent.innerHTML = `
                        <h2>Shipments</h2>
                        <p>Manage your shipments here</p>
                        <div id="shipmentsContainer"></div>
                    `;
                    loadShipments();
                    break;
                case 'Analytics':
                    location.hash = '#analytics';
                    dashboardContent.innerHTML = `
                        <h2>Analytics Dashboard</h2>
                        <div id="analyticsContainer"></div>
                    `;
                    loadAnalytics();
                    break;
                case 'Certifications':
                    location.hash = '#certifications';
                    dashboardContent.innerHTML = `
                        <h2>Certifications</h2>
                        <p>View and manage your certifications</p>
                    `;
                    break;
                case 'Wallet':
                    location.hash = '#wallet';
                    dashboardContent.innerHTML = `
                        <h2>Wallet</h2>
                        <p>Manage your wallet and payments</p>
                    `;
                    break;
                case 'Settings':
                    location.hash = '#settings';
                    dashboardContent.innerHTML = `
                        <h2>Settings</h2>
                        <p>Update your account settings</p>
                    `;
                    break;
            }
        }
    });
});

// Helper functions
async function loadUserProducts() {
    const token = localStorage.getItem('token');
    if (!token) {
        alert('Please login first');
        return;
    }
    try {
        const response = await fetch('http://localhost:5000/api/products?farmerOnly=true', {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        const data = await response.json();
        const container = document.getElementById('productsContainer');
        if (data.data && data.data.length > 0) {
            container.innerHTML = data.data.map(p => `
                <div class="stat-card">
                    <h5>${p.name}</h5>
                    <p>Price: $${p.pricePerUnit}</p>
                    <p>Stock: ${p.availableQuantity}</p>
                </div>
            `).join('');
        } else {
            container.innerHTML = '<p>No products found</p>';
        }
    } catch(err) {
        console.error('Error loading products:', err);
    }
}

async function loadShipments() {
    const token = localStorage.getItem('token');
    if (!token) return;
    try {
        const response = await fetch('http://localhost:5000/api/orders?status=shipped', {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        const data = await response.json();
        const container = document.getElementById('shipmentsContainer');
        if (data.data && data.data.length > 0) {
            container.innerHTML = data.data.map(o => `
                <div class="stat-card">
                    <h5>Order #${o._id}</h5>
                    <p>Status: ${o.status}</p>
                    <p>Total: $${o.totalAmount}</p>
                </div>
            `).join('');
        } else {
            container.innerHTML = '<p>No shipments found</p>';
        }
    } catch(err) {
        console.error('Error loading shipments:', err);
    }
}

async function loadAnalytics() {
    const token = localStorage.getItem('token');
    if (!token) return;
    try {
        const response = await fetch('http://localhost:5000/api/analytics/dashboard', {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        const data = await response.json();
        const container = document.getElementById('analyticsContainer');
        if (data.data) {
            const { totalSales, totalOrders, totalProducts } = data.data;
            container.innerHTML = `
                <div class="row">
                    <div class="col-md-4">
                        <div class="stat-card">
                            <div class="stat-value">$${totalSales || 0}</div>
                            <div class="stat-label">Total Sales</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card">
                            <div class="stat-value">${totalOrders || 0}</div>
                            <div class="stat-label">Total Orders</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card">
                            <div class="stat-value">${totalProducts || 0}</div>
                            <div class="stat-label">Total Products</div>
                        </div>
                    </div>
                </div>
            `;
        }
    } catch(err) {
        console.error('Error loading analytics:', err);
    }
}
```

---

### 4. Other Dashboard Logout Fix

**Applied to:** consumer-dashboard.html, retailer-dashboard.html, admin-dashboard.html

**NEW CODE:**
```javascript
// In menu-item click handler
const href = this.getAttribute('href');

// Allow logout to work normally
if (href === 'login.html') {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    return;
}
```

---

### 5. Backend Auth Imports (Multiple files)

**Applied to:** analytics.js, blockchain.js, notifications.js, orders.js

**BEFORE:**
```javascript
const auth = require('../middleware/auth');
```

**AFTER:**
```javascript
const { auth } = require('../middleware/auth');
```

---

### 6. Backend Blockchain Return Values

**File:** blockchain/blockchain.js

**BEFORE:**
```javascript
addTransaction(transaction) {
    this.pendingTransactions.push(transaction);
}
```

**AFTER:**
```javascript
addTransaction(transaction) {
    this.pendingTransactions.push(transaction);
    return this.getLatestBlock(); // Return block with hash
}
```

**BEFORE:**
```javascript
minePendingTransactions(minerAddress) {
    // Mine block...
}
```

**AFTER:**
```javascript
minePendingTransactions(minerAddress) {
    // Mine block...
    return this.getLatestBlock(); // Return newly mined block
}
```

---

### 7. Server.js Route Registration

**File:** backend/server.js

**ADDED:**
```javascript
// Import new routes
const cartRoutes = require('./routes/cart');
const membersRoutes = require('./routes/members');

// Register routes
app.use('/api/cart', cartRoutes);
app.use('/api/members', membersRoutes);

// Fix Blockchain import
const { Blockchain } = require('./blockchain/blockchain');
```

---

## Data Flow Diagram

```
User Registration
├─ Fills form (fullName, email, password, role, etc.)
├─ Clicks Submit
├─ POST /api/auth/register
├─ Backend validates & creates user
├─ Returns {token, user}
├─ Frontend: localStorage.setItem('token', token)
├─ Frontend: localStorage.setItem('user', user)
└─ Redirect to dashboard

User Login
├─ Selects role, enters email/password
├─ Clicks Login
├─ POST /api/auth/login
├─ Backend validates credentials
├─ Returns {token, user}
├─ Frontend: localStorage.setItem('token', token)
├─ Frontend: localStorage.setItem('user', user)
└─ Redirect to dashboard

Protected API Call
├─ Get token from localStorage
├─ Add header: 'Authorization: Bearer {token}'
├─ Call API endpoint
├─ Backend checks auth middleware
├─ Returns data if valid token
└─ Display in dashboard

Logout
├─ User clicks Logout menu item
├─ localStorage.removeItem('token')
├─ localStorage.removeItem('user')
└─ Redirect to login page
```

---

## Token Storage Structure

**localStorage Keys:**
```javascript
// Token key
localStorage.getItem('token')
// Returns: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

// User key (JSON string)
localStorage.getItem('user')
// Returns: '{"_id":"123","fullName":"John","email":"john@farm.com","role":"farmer"}'

// Parsed user
JSON.parse(localStorage.getItem('user'))
// Returns: {_id: "123", fullName: "John", email: "john@farm.com", role: "farmer"}
```

---

## API Header Format

**All Protected Endpoints Require:**
```javascript
fetch('http://localhost:5000/api/endpoint', {
    method: 'GET|POST|PUT|DELETE',
    headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token')}`
    },
    body: JSON.stringify(data) // For POST/PUT
})
```

---

**All changes ensure proper authentication flow, data persistence, and UI functionality.**
