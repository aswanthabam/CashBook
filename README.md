![Banner](https://raw.githubusercontent.com/aswanthabam/CashBook/main/banner_image.png)
# CashBook 💰📚

CashBook is a simple yet powerful personal finance management app built with Flutter. With CashBook, you can easily track your expenses, manage your liabilities, analyze your spending patterns, and stay on top of your finances effortlessly.

## Features 🚀

- **Expense Tracking:** Record your expenses quickly and conveniently.
- **Liability Management:** Keep track of your liabilities separately.
- **Tagging:** Categorize your expenses using tags with icons for easy identification.
- **Graphical Analytics:** Visualize your spending habits with intuitive graphs.
- **Export Functionality:** Export your financial data as PDF or Excel files for further analysis or record-keeping.
- **Simple UI:** Enjoy a clean and user-friendly interface designed for ease of use.

## Building the app 🛠️

Use the following two commands forr building the app, you can change the apk to other builds too.

### Android 

```bash
flutter pub get
flutter pub run build_runner build
flutter build apk --no-tree-shake-icons
```
> Note: While this project has been extensively tested and optimized for Android API versions 22 through 34, we warmly welcome iOS developers to contribute by testing and optimizing the app on the iOS platform.

## Contributing 🤝

Contributions are welcome! If you have any ideas, suggestions, or bug reports, feel free to open an issue or submit a pull request.

> Before contributing to the repository, please create an issue. 
> To request a new feature, create an issue with the label `feature`.

Please follow these patterns for commit message:
- Use the following syntax in the commit message: `<type>(<scope>): <description>`.
- Example commit types include `feat` for features, `fix` for bug fixes, `refactor` for code refactoring, `docs` for documentation updates, etc.
- Begin the commit message with a verb.
- Example: "feat(expense): Add feature to export data."

This ensures clarity and consistency in the commit history.

