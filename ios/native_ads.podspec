#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'native_ads'
  s.version          = '0.0.1'
  s.summary          = 'Flutter native ads with PlatformView'
  s.description      = <<-DESC
Flutter native ads with PlatformView
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Google-Mobile-Ads-SDK'

  s.ios.deployment_target = '8.0'

  s.static_framework = true
end

