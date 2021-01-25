#
# Be sure to run `pod lib lint CropPickerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CropPickerView'
  s.version          = '0.2.5'
  s.summary          = 'View with Crop screen'
  s.description      = <<-DESC
The Corner and Side buttons allow you to modify the position of the crop and UIScrollView to zoom the image. If the image is larger than the area of the UIScrollView, the image can be scrolled up and down, left and right, and if the image is smaller than the area of the UIScrollView, the image is always centered.
                       DESC
  s.homepage         = 'https://github.com/pikachu987/CropPickerView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pikachu987' => 'pikachu77769@gmail.com' }
  s.source           = { :git => 'https://github.com/pikachu987/CropPickerView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'CropPickerView/Classes/**/*'
  s.swift_version = '5.0'
end
