
<div style="position: relative;">
  <img src="https://raw.githubusercontent.com/rhythmhere/financial_tracker/refs/heads/main/applogo.png" align="right" width="30%" style="margin: -20px 0 0 20px;">
  <h1>Expenza</h1>
  <p><em>Personal finance & expense tracker app</em></p>
  <p>
    <img src="https://img.shields.io/github/license/rhythmhere/financial_tracker?style=default&logo=opensourceinitiative&logoColor=white&color=0080ff" alt="license">
    <img src="https://img.shields.io/github/last-commit/rhythmhere/financial_tracker?style=default&logo=git&logoColor=white&color=0080ff" alt="last-commit">
    <img src="https://img.shields.io/github/languages/top/rhythmhere/financial_tracker?style=default&color=0080ff" alt="repo-top-language">
    <img src="https://img.shields.io/github/languages/count/rhythmhere/financial_tracker?style=default&color=0080ff" alt="repo-language-count">
    <img src="https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white" alt="Flutter">
    <img src="https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white" alt="Dart">
  </p>
</div>
<br clear="right">

<h2>📍 Overview</h2>
<p><strong>Expenza</strong> is a sleek, modern <strong>personal finance app</strong> designed to help users <strong>track expenses, manage savings, and visualize investments</strong>. Built with <strong>Flutter</strong>, it works on both <strong>Android and iOS</strong>, giving a seamless cross-platform experience. The app focuses on <strong>simplicity, real-time tracking, and insightful financial analytics</strong>.</p>

<h2>👾 Features</h2>
<ul>
  <li><strong>Expense Tracking:</strong> Add, edit, and delete daily expenses with categories.</li>
  <li><strong>Savings Management:</strong> Keep track of your savings goals.</li>
  <li><strong>Investments Overview:</strong> Track investments and see visual summaries.</li>
  <li><strong>Liabilities:</strong> Record debts and other financial obligations.</li>
  <li><strong>Profile Management:</strong> Manage personal financial details in one place.</li>
  <li><strong>Interactive Charts:</strong> Bar charts for expenses and pie charts for investments.</li>
  <li><strong>Dark/Light Theme:</strong> Toggle between themes seamlessly.</li>
  <li><strong>Cross-platform:</strong> Runs on both iOS and Android.</li>
</ul>

<h2>📁 Project Structure</h2>
<pre>
financial_tracker/
├── android/
├── ios/
├── lib/
│   ├── db/
│   ├── models/
│   ├── providers/
│   ├── screens/
│   ├── widgets/
│   ├── main.dart
│   ├── theme.dart
│   └── theme_temp.dart
├── pubspec.yaml
├── pubspec.lock
└── README.md
</pre>
<p><strong>lib/db:</strong> Database helpers and SQL logic.<br>
<strong>lib/models:</strong> Expense, Saving, Investment, Liability, Profile data models.<br>
<strong>lib/providers:</strong> State management logic (AppState).<br>
<strong>lib/screens:</strong> All app screens (Dashboard, Expenses, Savings, Investments, Liabilities, Profile).<br>
<strong>lib/widgets:</strong> Reusable UI components (charts, cards, etc.).</p>

<h2>🚀 Getting Started</h2>

<h3>☑️ Prerequisites</h3>
<ul>
  <li>Flutter SDK (>= 3.0.0)</li>
  <li>Dart (>= 2.18)</li>
  <li>Android Studio or Xcode</li>
</ul>

<h3>⚙️ Installation</h3>
<pre>
git clone https://github.com/rhythmhere/financial_tracker.git
cd financial_tracker
flutter pub get
flutter run
</pre>

<h3>🤖 Usage</h3>
<p>After running <code>flutter run</code>, the app launches on your connected device or emulator. You can:</p>
<ul>
  <li>Add new expenses, savings, investments, and liabilities.</li>
  <li>Navigate between Dashboard, Expenses, Savings, Investments, Liabilities, and Profile screens.</li>
  <li>View interactive charts and summaries.</li>
  <li>Toggle between light and dark themes.</li>
</ul>

<h3>🧪 Testing</h3>
<pre>
flutter test
</pre>

<h2>📌 Project Roadmap</h2>
<ul>
  <li>✅ Implement Expense Tracking</li>
  <li>✅ Add Savings Management</li>
  <li>✅ Build Investment Overview</li>
  <li>❌ Add Budget Forecast & Alerts</li>
  <li>❌ Add Cloud Sync / Backup</li>
  <li>❌ Add Multi-Currency Support</li>
</ul>

<h2>🔰 Contributing</h2>
<ul>
  <li>💬 Discussions: <a href="https://github.com/rhythmhere/financial_tracker/discussions">GitHub Discussions</a></li>
  <li>🐛 Issues: <a href="https://github.com/rhythmhere/financial_tracker/issues">Report Bugs</a></li>
  <li>💡 Pull Requests: <a href="https://github.com/rhythmhere/financial_tracker/pulls">Submit PRs</a></li>
</ul>
<p><strong>Contributing Guidelines:</strong></p>
<ol>
  <li>Fork the repo and clone locally.</li>
  <li>Create a new branch: <code>git checkout -b feature-name</code></li>
  <li>Make changes and test thoroughly.</li>
  <li>Commit with clear messages and push.</li>
  <li>Open a pull request to the main repository.</li>
</ol>

<h2>🎗 License</h2>
<p>This project is licensed under the <strong>MIT License</strong>. See the <a href="https://choosealicense.com/licenses/mit/">LICENSE</a> file for details.</p>

<h2>🙌 Acknowledgments</h2>
<ul>
  <li>Flutter & Dart</li>
  <li><a href="https://material.io/resources/icons/">Material Design Icons</a></li>
  <li>Charting libraries (bar & pie charts)</li>
  <li>Inspiration from other personal finance apps</li>
</ul>

</body>
</html>