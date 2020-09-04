#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'intercom_flutter'
  s.version          = '2.2.0+1'
  s.summary          = 'Intercom integration for Flutter'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/ChangeFinance/intercom_flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'xChange OÜ' => 'maido@getchange.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Intercom'
  s.static_framework = true
  s.dependency 'Intercom', '~> 7.1.0'
  s.ios.deployment_target = '10.0'
end

