# TODO

## High Priority

- [ ] Replace jquery-datatables-rails with vendored DataTables + npm tracking
  - Remove `jquery-datatables-rails` gem dependency (currently pulls in
    `sass-rails` transitively)
  - Vendor DataTables assets directly in `vendor/assets/`
  - Add `package.json` for development to track DataTables updates via
    npm/Dependabot
  - Create update script to copy from `node_modules/` to `vendor/assets/`
  - Document versioning strategy in `vendor/assets/VENDORED_ASSETS.md`
  - Update gemspec to remove `jquery-datatables-rails` dependency
  - Test with consuming applications to verify functionality
