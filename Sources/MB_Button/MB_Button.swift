//
//  MB_Button.swift
//
//  Created by BLIN Michael on 25/01/2022.
//

import UIKit
import SnapKit

public class MB_Button : UIButton {
	
	public enum MB_Button_Style {
		
		case solid
		case tinted
		case gray
		case bordered
		case transparent
	}
	
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
			
			configuration?.contentInsets = .init(top: UI.Margins, leading: 1.5*UI.Margins, bottom: UI.Margins, trailing: 1.5*UI.Margins)
			configuration?.titleAlignment = .center
			configuration?.imagePlacement = imagePlacement
			configuration?.imagePadding = UI.Margins
			
			var titleAttributedString:AttributedString? = nil
			
			if let title = title {
				
				titleAttributedString = AttributedString.init(title)
				titleAttributedString?.font = titleFont
			}
			
			configuration?.attributedTitle = titleAttributedString
			
			var subtitleAttributedString:AttributedString? = nil
			
			if let subtitle = subtitle {
				
				subtitleAttributedString = AttributedString.init(subtitle)
				subtitleAttributedString?.font = subtitleFont
			}
			
			configuration?.attributedSubtitle = subtitleAttributedString
			
			addAction(.init(handler: { [weak self] _ in
				
				self?.action?(self)
				
			}), for: .touchUpInside)
		}
	}
	public var cornerStyle:UIButton.Configuration.CornerStyle = .dynamic {
		
		didSet {
			
			updateStyle()
		}
	}
	public var cornerRadius:CGFloat = UI.CornerRadius {
		
		didSet {
			
			updateStyle()
		}
	}
	public override var tintColor: UIColor! {
		
		didSet {
			
			updateStyle()
		}
	}
	public var title:String? {
		
		didSet {
			
			updateStyle()
		}
	}
	public var titleFont:UIFont = .boldSystemFont(ofSize: Fonts.Size.Default+2) {
		
		didSet {
			
			updateStyle()
		}
	}
	public var subtitle:String? {
		
		didSet {
			
			updateStyle()
		}
	}
	public var subtitleFont:UIFont = .systemFont(ofSize: Fonts.Size.Default-1) {
		
		didSet {
			
			updateStyle()
		}
	}
	public var image:UIImage? {
		
		didSet {
			
			configuration?.image = image?.withConfiguration(UIImage.SymbolConfiguration(scale: .large))
		}
	}
	public var imagePlacement:NSDirectionalRectEdge = .leading {
		
		didSet {
			
			updateStyle()
		}
	}
	public var isLoading:Bool = false {
		
		didSet {
			
			configuration?.showsActivityIndicator = isLoading
			isEnabled = !isLoading
		}
	}
	public var isTouchEffectEnabled:Bool = true
	private lazy var effectView:UIView = {
		
		let view:UIView = .init()
		view.clipsToBounds = true
		view.isUserInteractionEnabled = false
		return view
	}()
	public var action:((MB_Button?)->Void)?
	
	convenience init() {
		
		self.init(frame: .zero)
		
		setUp()
	}
	
	convenience init(_ title:String?, _ action:((MB_Button?)->Void)?) {
		
		self.init(frame: .zero)
		
		setUp()
		
		self.title = title
		self.action = action
	}
	
	open func setUp() {
		
		
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
