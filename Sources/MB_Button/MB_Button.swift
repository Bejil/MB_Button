//
//  MB_Button.swift
//
//  Created by BLIN Michael on 25/01/2022.
//

import UIKit
import SnapKit

/**
 Defines the possible styles of the button

 - solid: Filled button with tintColor
 - tinted: Alpha filled button with tintColor
 - gray: Gray background button
 - bordered: Button with tintColor borders
 - transparent: Button without background and borders
 */
public enum MB_Button_Style {
	
	case solid
	case tinted
	case gray
	case bordered
	case transparent
}

open class MB_Button : UIButton {
	
	//MARK: - Styles
	/**
	 Defines the current style of the button
	 - Note: Default value is `.solid`
	 */
	public var style:MB_Button_Style = .solid {
		
		didSet {
			
			if style == .solid {
				
				configuration = .filled()
			}
			else if style == .tinted {
				
				configuration = .tinted()
			}
			else if style == .gray {
				
				configuration = .gray()
			}
			else if style == .bordered || style == .transparent {
				
				configuration = .plain()
				
				if style == .bordered {
					
					configuration?.background.strokeColor = tintColor
					configuration?.background.strokeWidth = 1
				}
			}
			
			configuration?.cornerStyle = cornerStyle
			
			if cornerStyle == .fixed {
				
				configuration?.background.cornerRadius = cornerRadius
			}
			
			configuration?.contentInsets = contentInsets
			configuration?.titleAlignment = alignment
			configuration?.imagePlacement = imagePlacement
			configuration?.image = image?.withConfiguration(UIImage.SymbolConfiguration(scale: .large))
			configuration?.imagePadding = UI.Margins
			
			var titleAttributedString:AttributedString? = nil
			
			if let title = title {
				
				titleAttributedString = AttributedString.init(title)
				titleAttributedString?.font = titleFont
				titleAttributedString?.foregroundColor = titleColor
			}
			
			configuration?.attributedTitle = titleAttributedString
			
			var subtitleAttributedString:AttributedString? = nil
			
			if let subtitle = subtitle {
				
				subtitleAttributedString = AttributedString.init(subtitle)
				subtitleAttributedString?.font = subtitleFont
				titleAttributedString?.foregroundColor = subtitleColor
			}
			
			configuration?.attributedSubtitle = subtitleAttributedString
		}
	}
	//MARK: - UI
	/**
	 Defines the corner style of the button
	 - Note: Default value is `.dynamic`. Refer to `UIButton.Configuration.CornerStyle`
	 */
	public var cornerStyle:UIButton.Configuration.CornerStyle = .dynamic {
		
		didSet {
			
			updateStyle()
		}
	}
	/**
	 Defines the corner radius of the button
	 - Note: Only when `cornerStyle == .fixed`. Default value is `UI.CornerRadius`
	 */
	public var cornerRadius:CGFloat = UI.CornerRadius {
		
		didSet {
			
			updateStyle()
		}
	}
	/**
	 Defines the global tint of the button
	 */
	public override var tintColor: UIColor! {
		
		didSet {
			
			updateStyle()
		}
	}
	/**
	 Defines the color of the first line
	 */
	public var titleColor:UIColor? {
		
		didSet {
			
			updateStyle()
		}
	}
	/**
	 Defines the alignment of the first and second lines
	 */
	public var alignment:UIButton.Configuration.TitleAlignment = .center {
		
		didSet {
			
			updateStyle()
		}
	}
	/**
	 Defines the color of the second line
	 */
	public var subtitleColor:UIColor? {
		
		didSet {
			
			updateStyle()
		}
	}
	/**
	 Defines the placement of the image/icon of the button
	 - Note: Default value is `.leading`. Refer to `NSDirectionalRectEdge`
	 */
	public var imagePlacement:NSDirectionalRectEdge = .leading {
		
		didSet {
			
			updateStyle()
		}
	}
	/**
	 Defines the content insets
	 - Note: Default value is `.init(top: UI.Margins, leading: 1.5*UI.Margins, bottom: UI.Margins, trailing: 1.5*UI.Margins)`. Refer to `NSDirectionalEdgeInsets`
	 */
	public var contentInsets:NSDirectionalEdgeInsets = .init(top: UI.Margins, leading: 1.5*UI.Margins, bottom: UI.Margins, trailing: 1.5*UI.Margins) {
		
		didSet {
			
			updateStyle()
		}
	}
	//MARK: - Values
	/**
	 Defines the first line of the button
	 */
	public var title:String? {
		
		didSet {
			
			updateStyle()
		}
	}
	/**
	 Defines the second line of the button
	 */
	public var subtitle:String? {
		
		didSet {
			
			updateStyle()
		}
	}
	/**
	 Defines the image/icon of the button
	 */
	public var image:UIImage? {
		
		didSet {
			
			updateStyle()
		}
	}
	//MARK: - Fonts
	/**
	 Defines the first line's font of the button
	 - Note: Default value is `.boldSystemFont(ofSize: Fonts.Size.Default+2)`
	 */
	public var titleFont:UIFont? = .boldSystemFont(ofSize: Fonts.Size.Default+2) {
		
		didSet {
			
			updateStyle()
		}
	}
	/**
	 Defines the second line's font of the button
	 - Note: Default value is `.systemFont(ofSize: Fonts.Size.Default-1)`
	 */
	public var subtitleFont:UIFont? = .systemFont(ofSize: Fonts.Size.Default-1) {
		
		didSet {
			
			updateStyle()
		}
	}
	//MARK: - States
	/**
	 Display (or not) an `UIActivityIndicatorView` in place of the image
	 - Note: Default value is `false`
	 */
	public var isLoading:Bool = false {
		
		didSet {
			
			configuration?.showsActivityIndicator = isLoading
			isUserInteractionEnabled = !isLoading
		}
	}
	/**
	 Defines if an haptic and visual feedback should be active at touch
	 - Note: Default value is `true`
	 */
	public var isTouchEffectEnabled:Bool = true
	//MARK: - Events
	/**
	 Defines a closure to handle `.touchUpInside` event
	 */
	public var action:((MB_Button?)->Void)?
	
	//MARK: Private
	private lazy var effectView:UIView = {
		
		let view:UIView = .init()
		view.clipsToBounds = true
		view.isUserInteractionEnabled = false
		return view
	}()
	
	public convenience init() {
		
		self.init(frame: .zero)
		
		setUp()
	}
	
	public convenience init(style:MB_Button_Style = .solid, title:String? = nil, subtitle:String? = nil, image:UIImage? = nil, andCompletion action:((MB_Button?)->Void)? = nil) {
		
		self.init()
		
		self.style = style
		self.title = title
		self.subtitle = subtitle
		self.image = image
		self.action = action
		
		updateStyle()
	}
	
	open func setUp() {
		
		addAction(.init(handler: { [weak self] _ in
			
			self?.action?(self)
			
		}), for: .touchUpInside)
	}
	
	private func updateStyle() {
		
		style = { style }()
	}
	
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		super.touchesBegan(touches, with: event)
		
		if style != .transparent, isTouchEffectEnabled, let touch = event?.allTouches?.first, let touchView = touch.view {
			
			UIImpactFeedbackGenerator(style: .medium).impactOccurred()
			
			let effectContainerView:UIView = .init()
			effectContainerView.clipsToBounds = true
			touchView.addSubview(effectContainerView)
			
			effectContainerView.snp.makeConstraints { make in
				make.edges.equalToSuperview()
			}
			
			touchView.layoutIfNeeded()
			
			let touchLocation = touch.location(in: effectContainerView)
			
			let view:UIView = .init()
			view.backgroundColor = .white
			view.alpha = 0.25
			effectContainerView.addSubview(view)
			
			view.snp.makeConstraints { make in
				make.width.height.equalTo(0)
				make.center.equalTo(touchLocation)
			}
			
			let radius = max(effectContainerView.frame.size.width,effectContainerView.frame.size.height)
			
			UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut) {
				
				view.layer.cornerRadius = radius
				
				view.snp.updateConstraints { make in
					
					make.width.height.equalTo(2*radius)
				}
				
				view.layoutIfNeeded()
				view.alpha = 0.0
				
			} completion: { _ in
				
				effectContainerView.removeFromSuperview()
			}
		}
	}
}
