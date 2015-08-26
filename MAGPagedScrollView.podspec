Pod::Spec.new do |s|
  s.name         = "MAGPagedScrollView"
  s.version      = "0.0.4"
  s.summary      = "Paged managed scroll view from MadAppGang."

  s.description  = <<-DESC
		MAGPagedScrollView is scroll view that managed subviews as pages

		Custom transitions:
		* None - regilar scroll
		* Slide
		* Dice
		* Roll
		* Cards
		* Custom

		### YouTube:
		[![youtube](http://img.youtube.com/vi/4xZoOypS128/0.jpg)](http://www.youtube.com/watch?v=4xZoOypS128)
                DESC

  s.homepage     = "https://github.com/MadAppGang/MAGPagedScrollView"

  s.license      = "MIT"
  s.author       = { "Ievgen Rudenko" => "i@madappgang.com" }

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/MadAppGang/MAGPagedScrollView.git", :tag => "0.0.4" }
  s.source_files = "MAGPagedScrollView", "MAGPagedScrollView/**/*.{swift}"
  s.requires_arc = true
end
