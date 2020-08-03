#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'native_ads'
  s.version          = '0.5.0'
  s.swift_version    = '5.0'
  s.summary          = 'Flutter native ads with PlatformView'
  s.description      = <<-DESC
Flutter native ads with PlatformView
                       DESC
  s.homepage         = 'https://github.com/sakebook/flutter_native_ads'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'sakebook' => 'sakebook@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Google-Mobile-Ads-SDK'

  s.ios.deployment_target = '10.0'

  s.static_framework = true
end

