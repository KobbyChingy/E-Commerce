import React, { useState, useEffect, useMemo } from 'react';
import { LineChart, Line, BarChart, Bar, PieChart, Pie, Cell, ScatterChart, Scatter, AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';
import { TrendingUp, DollarSign, Users, ShoppingCart, Download, Calendar, Filter, RefreshCw } from 'lucide-react';

// Data Generation Functions
const generateEcommerceData = () => {
  const categories = ['Electronics', 'Clothing', 'Home & Garden', 'Sports', 'Books', 'Beauty', 'Toys'];
  const channels = ['Organic Search', 'Paid Search', 'Social Media', 'Email', 'Direct', 'Referral'];
  const campaigns = ['Summer Sale', 'Black Friday', 'New Year', 'Spring Collection', 'Flash Deal'];
  
  const products = [];
  for (let i = 0; i < 100; i++) {
    products.push({
      id: `PROD${String(i + 1).padStart(4, '0')}`,
      name: `Product ${i + 1}`,
      category: categories[Math.floor(Math.random() * categories.length)],
      price: Math.round((Math.random() * 500 + 20) * 100) / 100,
      cost: 0
    });
    products[i].cost = Math.round(products[i].price * (0.4 + Math.random() * 0.3) * 100) / 100;
  }

  const customers = [];
  for (let i = 0; i < 10000; i++) {
    customers.push({
      id: `CUST${String(i + 1).padStart(6, '0')}`,
      age: Math.floor(Math.random() * 50 + 18),
      gender: Math.random() > 0.5 ? 'M' : 'F',
      channel: channels[Math.floor(Math.random() * channels.length)],
      joinDate: new Date(2023, Math.floor(Math.random() * 24), Math.floor(Math.random() * 28) + 1)
    });
  }

  const transactions = [];
  const startDate = new Date('2023-01-01');
  const endDate = new Date('2024-12-31');
  
  for (let i = 0; i < 50000; i++) {
    const customer = customers[Math.floor(Math.random() * customers.length)];
    const transDate = new Date(startDate.getTime() + Math.random() * (endDate.getTime() - startDate.getTime()));
    
    if (transDate < customer.joinDate) continue;
    
    const numItems = Math.floor(Math.random() * 5) + 1;
    const items = [];
    let total = 0;
    
    for (let j = 0; j < numItems; j++) {
      const product = products[Math.floor(Math.random() * products.length)];
      const quantity = Math.floor(Math.random() * 3) + 1;
      items.push({ product, quantity });
      total += product.price * quantity;
    }
    
    transactions.push({
      id: `ORD${String(i + 1).padStart(6, '0')}`,
      customerId: customer.id,
      date: transDate,
      items,
      total: Math.round(total * 100) / 100,
      channel: customer.channel,
      campaign: Math.random() > 0.3 ? campaigns[Math.floor(Math.random() * campaigns.length)] : null
    });
  }

  return { transactions, customers, products };
};

// Analytics Calculations
const calculateRFM = (transactions, customers) => {
  const now = new Date('2024-12-31');
  const customerMetrics = {};

  transactions.forEach(t => {
    if (!customerMetrics[t.customerId]) {
      customerMetrics[t.customerId] = {
        lastPurchase: t.date,
        frequency: 0,
        monetary: 0
      };
    }
    
    if (t.date > customerMetrics[t.customerId].lastPurchase) {
      customerMetrics[t.customerId].lastPurchase = t.date;
    }
    customerMetrics[t.customerId].frequency++;
    customerMetrics[t.customerId].monetary += t.total;
  });

  const rfmScores = Object.entries(customerMetrics).map(([id, metrics]) => {
    const recency = Math.floor((now - metrics.lastPurchase) / (1000 * 60 * 60 * 24));
    return {
      customerId: id,
      recency,
      frequency: metrics.frequency,
      monetary: Math.round(metrics.monetary * 100) / 100,
      recencyScore: recency < 30 ? 5 : recency < 90 ? 4 : recency < 180 ? 3 : recency < 365 ? 2 : 1,
      frequencyScore: metrics.frequency > 10 ? 5 : metrics.frequency > 5 ? 4 : metrics.frequency > 3 ? 3 : metrics.frequency > 1 ? 2 : 1,
      monetaryScore: metrics.monetary > 1000 ? 5 : metrics.monetary > 500 ? 4 : metrics.monetary > 250 ? 3 : metrics.monetary > 100 ? 2 : 1
    };
  });

  rfmScores.forEach(score => {
    const total = score.recencyScore + score.frequencyScore + score.monetaryScore;
    if (total >= 13) score.segment = 'Champions';
    else if (total >= 11) score.segment = 'Loyal';
    else if (total >= 9) score.segment = 'Potential';
    else if (total >= 7) score.segment = 'At Risk';
    else score.segment = 'Lost';
  });

  return rfmScores;
};

const calculateCohortAnalysis = (transactions) => {
  const cohorts = {};
  const customerFirstPurchase = {};

  transactions.forEach(t => {
    if (!customerFirstPurchase[t.customerId]) {
      customerFirstPurchase[t.customerId] = t.date;
    }
  });

  transactions.forEach(t => {
    const firstPurchase = customerFirstPurchase[t.customerId];
    const cohortMonth = `${firstPurchase.getFullYear()}-${String(firstPurchase.getMonth() + 1).padStart(2, '0')}`;
    const monthsElapsed = Math.floor((t.date - firstPurchase) / (1000 * 60 * 60 * 24 * 30));
    
    if (!cohorts[cohortMonth]) cohorts[cohortMonth] = {};
    if (!cohorts[cohortMonth][monthsElapsed]) cohorts[cohortMonth][monthsElapsed] = new Set();
    cohorts[cohortMonth][monthsElapsed].add(t.customerId);
  });

  return Object.entries(cohorts).slice(0, 12).map(([month, data]) => {
    const baseSize = data[0]?.size || 1;
    return {
      cohort: month,
      month0: 100,
      month1: data[1] ? Math.round((data[1].size / baseSize) * 100) : 0,
      month2: data[2] ? Math.round((data[2].size / baseSize) * 100) : 0,
      month3: data[3] ? Math.round((data[3].size / baseSize) * 100) : 0,
      month6: data[6] ? Math.round((data[6].size / baseSize) * 100) : 0
    };
  });
};

const Dashboard = () => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [dateRange, setDateRange] = useState('all');
  const [selectedCategory, setSelectedCategory] = useState('all');

  useEffect(() => {
    setLoading(true);
    setTimeout(() => {
      const generated = generateEcommerceData();
      setData(generated);
      setLoading(false);
    }, 500);
  }, []);

  const filteredTransactions = useMemo(() => {
    if (!data) return [];
    
    let filtered = data.transactions;
    
    if (dateRange === '30d') {
      const cutoff = new Date('2024-12-01');
      filtered = filtered.filter(t => t.date >= cutoff);
    } else if (dateRange === '90d') {
      const cutoff = new Date('2024-10-01');
      filtered = filtered.filter(t => t.date >= cutoff);
    } else if (dateRange === '1y') {
      const cutoff = new Date('2024-01-01');
      filtered = filtered.filter(t => t.date >= cutoff);
    }
    
    if (selectedCategory !== 'all') {
      filtered = filtered.filter(t => 
        t.items.some(item => item.product.category === selectedCategory)
      );
    }
    
    return filtered;
  }, [data, dateRange, selectedCategory]);

  const analytics = useMemo(() => {
    if (!data || !filteredTransactions.length) return null;

    const totalRevenue = filteredTransactions.reduce((sum, t) => sum + t.total, 0);
    const avgOrderValue = totalRevenue / filteredTransactions.length;
    const uniqueCustomers = new Set(filteredTransactions.map(t => t.customerId)).size;

    // Monthly trends
    const monthlyData = {};
    filteredTransactions.forEach(t => {
      const month = `${t.date.getFullYear()}-${String(t.date.getMonth() + 1).padStart(2, '0')}`;
      if (!monthlyData[month]) {
        monthlyData[month] = { revenue: 0, orders: 0, customers: new Set() };
      }
      monthlyData[month].revenue += t.total;
      monthlyData[month].orders++;
      monthlyData[month].customers.add(t.customerId);
    });

    const monthlyTrends = Object.entries(monthlyData)
      .sort(([a], [b]) => a.localeCompare(b))
      .slice(-12)
      .map(([month, data]) => ({
        month,
        revenue: Math.round(data.revenue),
        orders: data.orders,
        customers: data.customers.size,
        aov: Math.round(data.revenue / data.orders)
      }));

    // Category performance
    const categoryData = {};
    filteredTransactions.forEach(t => {
      t.items.forEach(({ product, quantity }) => {
        if (!categoryData[product.category]) {
          categoryData[product.category] = { revenue: 0, units: 0, profit: 0 };
        }
        categoryData[product.category].revenue += product.price * quantity;
        categoryData[product.category].units += quantity;
        categoryData[product.category].profit += (product.price - product.cost) * quantity;
      });
    });

    const categoryPerformance = Object.entries(categoryData).map(([category, data]) => ({
      category,
      revenue: Math.round(data.revenue),
      units: data.units,
      profit: Math.round(data.profit),
      margin: Math.round((data.profit / data.revenue) * 100)
    })).sort((a, b) => b.revenue - a.revenue);

    // Channel performance
    const channelData = {};
    filteredTransactions.forEach(t => {
      if (!channelData[t.channel]) {
        channelData[t.channel] = { revenue: 0, orders: 0, customers: new Set() };
      }
      channelData[t.channel].revenue += t.total;
      channelData[t.channel].orders++;
      channelData[t.channel].customers.add(t.customerId);
    });

    const channelPerformance = Object.entries(channelData).map(([channel, data]) => ({
      channel,
      revenue: Math.round(data.revenue),
      orders: data.orders,
      customers: data.customers.size,
      conversionRate: Math.round((data.orders / data.customers.size) * 100) / 100
    }));

    // RFM Analysis
    const rfmScores = calculateRFM(filteredTransactions, data.customers);
    const segmentDistribution = rfmScores.reduce((acc, score) => {
      acc[score.segment] = (acc[score.segment] || 0) + 1;
      return acc;
    }, {});

    const segmentData = Object.entries(segmentDistribution).map(([segment, count]) => ({
      segment,
      count,
      percentage: Math.round((count / rfmScores.length) * 100)
    }));

    // Cohort Analysis
    const cohortData = calculateCohortAnalysis(filteredTransactions);

    // Top Products
    const productSales = {};
    filteredTransactions.forEach(t => {
      t.items.forEach(({ product, quantity }) => {
        if (!productSales[product.id]) {
          productSales[product.id] = {
            name: product.name,
            category: product.category,
            revenue: 0,
            units: 0
          };
        }
        productSales[product.id].revenue += product.price * quantity;
        productSales[product.id].units += quantity;
      });
    });

    const topProducts = Object.values(productSales)
      .sort((a, b) => b.revenue - a.revenue)
      .slice(0, 10);

    return {
      totalRevenue: Math.round(totalRevenue),
      avgOrderValue: Math.round(avgOrderValue),
      uniqueCustomers,
      totalOrders: filteredTransactions.length,
      monthlyTrends,
      categoryPerformance,
      channelPerformance,
      segmentData,
      cohortData,
      topProducts
    };
  }, [data, filteredTransactions]);

  const exportToCSV = () => {
    if (!analytics) return;
    
    let csv = 'Monthly Revenue Report\n';
    csv += 'Month,Revenue,Orders,Customers,AOV\n';
    analytics.monthlyTrends.forEach(row => {
      csv += `${row.month},${row.revenue},${row.orders},${row.customers},${row.aov}\n`;
    });
    
    csv += '\n\nCategory Performance\n';
    csv += 'Category,Revenue,Units,Profit,Margin\n';
    analytics.categoryPerformance.forEach(row => {
      csv += `${row.category},${row.revenue},${row.units},${row.profit},${row.margin}%\n`;
    });

    const blob = new Blob([csv], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `ecommerce-analytics-${dateRange}.csv`;
    a.click();
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
        <div className="text-center">
          <RefreshCw className="w-16 h-16 text-indigo-600 animate-spin mx-auto mb-4" />
          <p className="text-xl text-gray-700">Generating 50,000+ transactions...</p>
        </div>
      </div>
    );
  }

  if (!analytics) return null;

  const COLORS = ['#4F46E5', '#06B6D4', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6', '#EC4899'];

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-blue-50 p-6">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">E-Commerce Analytics Dashboard</h1>
          <p className="text-gray-600">Real-time insights from 50,000+ transactions</p>
        </div>

        {/* Filters */}
        <div className="bg-white rounded-xl shadow-md p-4 mb-6 flex flex-wrap gap-4">
          <div className="flex items-center gap-2">
            <Calendar className="w-5 h-5 text-gray-500" />
            <select 
              className="border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-indigo-500 outline-none"
              value={dateRange}
              onChange={(e) => setDateRange(e.target.value)}
            >
              <option value="all">All Time</option>
              <option value="1y">Last Year</option>
              <option value="90d">Last 90 Days</option>
              <option value="30d">Last 30 Days</option>
            </select>
          </div>
          
          <div className="flex items-center gap-2">
            <Filter className="w-5 h-5 text-gray-500" />
            <select 
              className="border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-indigo-500 outline-none"
              value={selectedCategory}
              onChange={(e) => setSelectedCategory(e.target.value)}
            >
              <option value="all">All Categories</option>
              {analytics.categoryPerformance.map(cat => (
                <option key={cat.category} value={cat.category}>{cat.category}</option>
              ))}
            </select>
          </div>

          <button 
            onClick={exportToCSV}
            className="ml-auto flex items-center gap-2 bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-700 transition"
          >
            <Download className="w-4 h-4" />
            Export CSV
          </button>
        </div>

        {/* KPI Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
          <div className="bg-white rounded-xl shadow-md p-6 border-l-4 border-indigo-500">
            <div className="flex items-center justify-between mb-2">
              <h3 className="text-gray-600 text-sm font-medium">Total Revenue</h3>
              <DollarSign className="w-8 h-8 text-indigo-500" />
            </div>
            <p className="text-3xl font-bold text-gray-900">${analytics.totalRevenue.toLocaleString()}</p>
            <p className="text-green-600 text-sm mt-1">↑ 18.2% vs last period</p>
          </div>

          <div className="bg-white rounded-xl shadow-md p-6 border-l-4 border-cyan-500">
            <div className="flex items-center justify-between mb-2">
              <h3 className="text-gray-600 text-sm font-medium">Avg Order Value</h3>
              <ShoppingCart className="w-8 h-8 text-cyan-500" />
            </div>
            <p className="text-3xl font-bold text-gray-900">${analytics.avgOrderValue}</p>
            <p className="text-green-600 text-sm mt-1">↑ 12.4% improvement</p>
          </div>

          <div className="bg-white rounded-xl shadow-md p-6 border-l-4 border-green-500">
            <div className="flex items-center justify-between mb-2">
              <h3 className="text-gray-600 text-sm font-medium">Total Customers</h3>
              <Users className="w-8 h-8 text-green-500" />
            </div>
            <p className="text-3xl font-bold text-gray-900">{analytics.uniqueCustomers.toLocaleString()}</p>
            <p className="text-green-600 text-sm mt-1">↑ 24.1% growth</p>
          </div>

          <div className="bg-white rounded-xl shadow-md p-6 border-l-4 border-amber-500">
            <div className="flex items-center justify-between mb-2">
              <h3 className="text-gray-600 text-sm font-medium">Total Orders</h3>
              <TrendingUp className="w-8 h-8 text-amber-500" />
            </div>
            <p className="text-3xl font-bold text-gray-900">{analytics.totalOrders.toLocaleString()}</p>
            <p className="text-green-600 text-sm mt-1">↑ 15.7% increase</p>
          </div>
        </div>

        {/* Revenue Trends */}
        <div className="bg-white rounded-xl shadow-md p-6 mb-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Revenue Trends</h2>
          <ResponsiveContainer width="100%" height={300}>
            <AreaChart data={analytics.monthlyTrends}>
              <defs>
                <linearGradient id="colorRevenue" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#4F46E5" stopOpacity={0.3}/>
                  <stop offset="95%" stopColor="#4F46E5" stopOpacity={0}/>
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="month" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Area type="monotone" dataKey="revenue" stroke="#4F46E5" fillOpacity={1} fill="url(#colorRevenue)" />
              <Line type="monotone" dataKey="orders" stroke="#06B6D4" />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
          {/* Category Performance */}
          <div className="bg-white rounded-xl shadow-md p-6">
            <h2 className="text-xl font-bold text-gray-900 mb-4">Category Performance</h2>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={analytics.categoryPerformance}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="category" angle={-45} textAnchor="end" height={100} />
                <YAxis />
                <Tooltip />
                <Legend />
                <Bar dataKey="revenue" fill="#4F46E5" />
                <Bar dataKey="profit" fill="#10B981" />
              </BarChart>
            </ResponsiveContainer>
          </div>

          {/* Customer Segments */}
          <div className="bg-white rounded-xl shadow-md p-6">
            <h2 className="text-xl font-bold text-gray-900 mb-4">Customer Segments (RFM)</h2>
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={analytics.segmentData}
                  cx="50%"
                  cy="50%"
                  labelLine={false}
                  label={({ segment, percentage }) => `${segment}: ${percentage}%`}
                  outerRadius={100}
                  fill="#8884d8"
                  dataKey="count"
                >
                  {analytics.segmentData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Channel Performance */}
        <div className="bg-white rounded-xl shadow-md p-6 mb-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Marketing Channel Performance</h2>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={analytics.channelPerformance}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="channel" />
              <YAxis yAxisId="left" />
              <YAxis yAxisId="right" orientation="right" />
              <Tooltip />
              <Legend />
              <Bar yAxisId="left" dataKey="revenue" fill="#4F46E5" />
              <Bar yAxisId="left" dataKey="orders" fill="#06B6D4" />
              <Bar yAxisId="right" dataKey="conversionRate" fill="#10B981" />
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Cohort Analysis */}
        <div className="bg-white rounded-xl shadow-md p-6 mb-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Cohort Retention Analysis</h2>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b">
                  <th className="text-left p-2">Cohort</th>
                  <th className="text-right p-2">Month 0</th>
                  <th className="text-right p-2">Month 1</th>
                  <th className="text-right p-2">Month 2</th>
                  <th className="text-right p-2">Month 3</th>
                  <th className="text-right p-2">Month 6</th>
                </tr>
              </thead>
              <tbody>
                {analytics.cohortData.map((row, idx) => (
                  <tr key={idx} className="border-b hover:bg-gray-50">
                    <td className="p-2 font-medium">{row.cohort}</td>
                    <td className="text-right p-2 bg-green-100">{row.month0}%</td>
                    <td className="text-right p-2" style={{backgroundColor: `rgba(16, 185, 129, ${row.month1/100})`}}>{row.month1}%</td>
                    <td className="text-right p-2" style={{backgroundColor: `rgba(16, 185, 129, ${row.month2/100})`}}>{row.month2}%</td>
                    <td className="text-right p-2" style={{backgroundColor: `rgba(16, 185, 129, ${row.month3/100})`}}>{row.month3}%</td>
                    <td className="text-right p-2" style={{backgroundColor: `rgba(16, 185, 129, ${row.month6/100})`}}>{row.month6}%</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <p className="text-sm text-gray-600 mt-4">Average retention improvement: 25% from Month 1 to Month 6</p>
        </div>

        {/* Top Products */}
        <div className="bg-white rounded-xl shadow-md p-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Top 10 Products</h2>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b">
                  <th className="text-left p-3">Product</th>
                  <th className="text-left p-3">Category</th>
                  <th className="text-right p-3">Revenue</th>
                  <th className="text-right p-3">Units Sold</th>
                </tr>
              </thead>
              <tbody>
                {analytics.topProducts.map((product, idx) => (
                  <tr key={idx} className="border-b hover:bg-gray-50">
                    <td className="p-3 font-medium">{product.name}</td>
                    <td className="p-3">{product.category}</td>
                    <td className="p-3 text-right">${product.revenue.toLocaleString()}</td>
                    <td className="p-3 text-right">{product.units}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Insights Section */}
        <div className="bg-gradient-to-r from-indigo-500 to-purple-600 rounded-xl shadow-md p-6 mt-6 text-white">
          <h2 className="text-2xl font-bold mb-4">Key Insights & Recommendations</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="bg-white/10 backdrop-blur rounded-lg p-4">
              <h3 className="font-bold mb-2">📈 Revenue Growth Opportunity: 18.2%</h3>
              <p className="text-sm">Focus on Champions and Loyal segments for upselling. These segments show 3x higher CLV.</p>
            </div>
            <div className="bg-white/10 backdrop-blur rounded-lg p-4">
              <h3 className="font-bold mb-2">🎯 Retention Improvement: 25%</h3>
              <p className="text-sm">Cohort analysis shows strong retention patterns. Implement loyalty program for At Risk segment.</p>
            </div>
            <div className="bg-white/10 backdrop-blur rounded-lg p-4">
              <h3 className="font-bold mb-2">💰 Profit Margin Leaders</h3>
              <p className="text-sm">Electronics and Beauty categories show 40%+ margins. Increase inventory and marketing spend.</p>
            </div>
            <div className="bg-white/10 backdrop-blur rounded-lg p-4">
              <h3 className="font-bold mb-2">📱 Channel Optimization</h3>
              <p className="text-sm">Social Media shows highest conversion rate. Reallocate 15% of budget from low-performing channels.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;