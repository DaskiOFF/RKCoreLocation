#
# Be sure to run `pod lib lint RKCoreLocation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RKCoreLocation'
  s.version          = '0.1.1'
  s.summary          = 'Easy Core Location'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Easy Core Location
  
  0.1.1
    Update

  0.1.0
    Init
                       DESC

  s.homepage         = 'https://github.com/DaskiOFF/RKCoreLocation'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DaskiOFF' => 'waydeveloper@gmail.com' }
  s.source           = { :git => 'https://github.com/DaskiOFF/RKCoreLocation.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sources/**/*'
  
  # s.resource_bundles = {
  #   'RKCoreLocation' => ['RKCoreLocation/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'CoreLocation'
end
