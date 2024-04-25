![Banner](https://raw.githubusercontent.com/aswanthabam/CashBook/main/banner_image.png)
# Cashbook

Personal finance management app developed for tracking your expenses, earnings and savings. 

## Contributing

The project is open for contribution, please note the below points before creating a pull request.

- Before creating a pull request create an issue about the bug or the feature request, and let's discuss about it first.
- Commit message should have the follwing format 
    `<type>(<feature>) : <short_description>`
    - Type can be 
        - feat : A new feature or functionality
        - fix : An issue fix
        - docs : Documentation changes
        - refactor : Code reformation without changing functionalities.

## Building

Use the following two commands forr building the app, you can change the apk to other builds too.

```bash
flutter pub run build_runner build
flutter build apk --no-tree-shake-icons
```
> Note: While this project has been extensively tested and optimized for Android API versions 22 through 34, we warmly welcome iOS developers to contribute by testing and optimizing the app on the iOS platform.
