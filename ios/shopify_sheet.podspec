#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint shopify_sheet.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'shopify_sheet'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'farooqafridi958@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'shopify_sheet/Sources/shopify_sheet/**/*.swift'
  s.resource_bundles = {
    'shopify_sheet_privacy' => ['shopify_sheet/Sources/shopify_sheet/Resources/PrivacyInfo.xcprivacy']
  }
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.dependency 'ShopifyCheckoutSheetKit', '~> 3'
end
