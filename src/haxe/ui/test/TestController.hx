package haxe.ui.test;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import haxe.ui.toolkit.events.ListViewEvent;
import haxe.ui.toolkit.events.MenuEvent;
import haxe.ui.toolkit.containers.Accordion;
import haxe.ui.toolkit.containers.ListView;
import haxe.ui.toolkit.containers.Stack;
import haxe.ui.toolkit.containers.TabView;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.CheckBox;
import haxe.ui.toolkit.controls.extended.Code;
import haxe.ui.toolkit.controls.HSlider;
import haxe.ui.toolkit.controls.OptionBox;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.controls.selection.List;
import haxe.ui.toolkit.controls.Slider;
import haxe.ui.toolkit.controls.VScroll;
import haxe.ui.toolkit.core.Controller;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.resources.ResourceManager;
import haxe.ui.toolkit.controls.Progress;
import haxe.ui.toolkit.style.DefaultStyles;
import haxe.ui.toolkit.style.StyleManager;
import haxe.ui.toolkit.util.psuedothreads.AsyncThreadCaller;
import haxe.ui.toolkit.util.psuedothreads.Runner;

class TestController extends XMLController {
	public function new() {
		var resourceId:String = "ui/test02.xml";
		super(resourceId);
		
		if (resourceId != "ui/test02.xml") {
			return;
		}

		attachEvent("menu1", MenuEvent.SELECT, function(e:MenuEvent) {
			trace(e.menuItem.id);
			var mainTabs:TabView = getComponentAs("mainTabs", TabView);
			mainTabs.selectedIndex = 3;
		});
		
		attachEvent("perfButton", MouseEvent.CLICK, function(e) {
			trace("perf");
			var b:Button = getComponentAs("perfButton", Button);
			b.text = "bbbbbbbbbbbbbbbbbbbbbb";
			var mainTabs:TabView = getComponentAs("mainTabs", TabView);
			mainTabs.setTabText(0, "xxxxxxxxxxxxxxxxxxxxxxxxxxx");
			//mainTabs.invalidate();
			mainTabs.selectedIndex = 2;
			/*
			var b:Button = getComponentAs("perfButton", Button);
			for (x in 0...354) {
			}
			
			StyleManager.instance.dump();
			
			*/
			StyleManager.instance.dump();
		});
		
		attachEvent("showSimplePopup", MouseEvent.CLICK, function(e) {
			PopupManager.instance.showSimple(root, "Basic poup text", "Simple Popup");
		});

		attachEvent("showConfirmPopup", MouseEvent.CLICK, function(e) {
			PopupManager.instance.showSimple(root, "Are you sure you wish to perform this action?\n\nBad things could happen!", "Confirm Action", PopupButtonType.YES | PopupButtonType.NO, function(b) {
				if (b == PopupButtonType.YES) {
					PopupManager.instance.showSimple(root, "You clicked 'Yes'.", "Result");
				} else if (b == PopupButtonType.NO) {
					PopupManager.instance.showSimple(root, "You clicked 'No'.", "Result");
				}
			});
		});

		attachEvent("showCustomPopup", MouseEvent.CLICK, function(e) {
			var popupController:XMLController = new XMLController("ui/customPopup.xml");
			PopupManager.instance.showCustom(root, popupController.view, "Enter Name", PopupButtonType.CONFIRM | PopupButtonType.CANCEL, function (b) {
				if (b == PopupButtonType.CONFIRM) {
					var name:String = popupController.getComponent("firstName").text + " " + popupController.getComponent("lastName").text;
					PopupManager.instance.showSimple(root, "Hello " + name + "!!!", "Welcome!");
				}
			});
		});

		attachEvent("showListPopup", MouseEvent.CLICK, function(e) {
			PopupManager.instance.showList(root, ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"], "Select Item", 1, function (item:ListViewItem) {
				PopupManager.instance.showSimple(root, "You selected '" + item.text + "'", "Selection");
			});
		});

		attachEvent("showCalendarPopup", MouseEvent.CLICK, function(e) {
			PopupManager.instance.showCalendar(root, "Select Date");
		});

		attachEvent("showBusyPopup", MouseEvent.CLICK, function(e) {
			PopupManager.instance.showBusy(root, "Busy, please wait", 3000, "Waiting");
		});
		
		attachEvent("theList", ListViewEvent.COMPONENT_EVENT, function (e:ListViewEvent) {
			if (Std.is(e.component, Button)) {
				PopupManager.instance.showSimple(root, "You clicked: " + e.component.text + "!", "Alert!");
			} else if (Std.is(e.component, HSlider)) {
				e.item.subtext = "Slider value: " + Std.int(cast(e.component, HSlider).pos);
			}
		});
		
		attachEvent("styleList", Event.CHANGE, function(e) {
			var style:String = getComponentAs("styleList", List).selectedItems[0].text.toLowerCase();
			RootManager.instance.destroyAllRoots();
			//Toolkit.defaultStyle = style;
			StyleManager.instance.clear();
			ResourceManager.instance.reset();
			if (style == "gradient") {
				Macros.addStyleSheet("styles/gradient/gradient.css");
			} else if (style == "gradient mobile") {
				Macros.addStyleSheet("styles/gradient/gradient_mobile.css");				
			} else if (style == "windows") {
				Macros.addStyleSheet("styles/windows/windows.css");
				Macros.addStyleSheet("styles/windows/buttons.css");
				Macros.addStyleSheet("styles/windows/tabs.css");
				Macros.addStyleSheet("styles/windows/listview.css");
				Macros.addStyleSheet("styles/windows/scrolls.css");
				Macros.addStyleSheet("styles/windows/sliders.css");
				Macros.addStyleSheet("styles/windows/accordion.css");
				Macros.addStyleSheet("styles/windows/rtf.css");
				Macros.addStyleSheet("styles/windows/calendar.css");
				Macros.addStyleSheet("styles/windows/popups.css");
				Macros.addStyleSheet("styles/windows/menus.css");
			} else if (style == "default") {
				StyleManager.instance.addStyles(new DefaultStyles());
			}
			Toolkit.openFullscreen(function(root:Root) {
				root.addChild(new TestController().view);
			});
		});

		// set demo tab values
		{
			var accordionTrans:String = Toolkit.getTransitionForClass(Accordion);
			if (accordionTrans == "none") {
				getComponentAs("accordionTransNone", OptionBox).selected = true;
			} else if (accordionTrans == "fade") {
				getComponentAs("accordionTransFade", OptionBox).selected = true;
			} else if (accordionTrans == "slide") {
				getComponentAs("accordionTransSlide", OptionBox).selected = true;
			}
			
			attachEvent("accordionTransNone", Event.CHANGE, function(e) {
				if (getComponentAs("accordionTransNone", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Accordion, "none");
				}
			});
			attachEvent("accordionTransFade", Event.CHANGE, function(e) {
				if (getComponentAs("accordionTransFade", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Accordion, "fade");
				}
			});
			attachEvent("accordionTransSlide", Event.CHANGE, function(e) {
				if (getComponentAs("accordionTransSlide", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Accordion, "slide");
				}
			});
		}
		
		{
			var stackTrans:String = Toolkit.getTransitionForClass(Stack);
			if (stackTrans == "none") {
				getComponentAs("tabViewTransNone", OptionBox).selected = true;
			} else if (stackTrans == "fade") {
				getComponentAs("tabViewTransFade", OptionBox).selected = true;
			} else if (stackTrans == "slide") {
				getComponentAs("tabViewTransSlide", OptionBox).selected = true;
			}
			
			attachEvent("tabViewTransNone", Event.CHANGE, function(e) {
				if (getComponentAs("tabViewTransNone", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Stack, "none");
				}
			});
			attachEvent("tabViewTransFade", Event.CHANGE, function(e) {
				if (getComponentAs("tabViewTransFade", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Stack, "fade");
				}
			});
			attachEvent("tabViewTransSlide", Event.CHANGE, function(e) {
				if (getComponentAs("tabViewTransSlide", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Stack, "slide");
				}
			});
		}
		
		{
			var dropDownTrans:String = Toolkit.getTransitionForClass(List);
			if (dropDownTrans == "none") {
				getComponentAs("dropDownTransNone", OptionBox).selected = true;
			} else if (dropDownTrans == "fade") {
				getComponentAs("dropDownTransFade", OptionBox).selected = true;
			} else if (dropDownTrans == "slide") {
				getComponentAs("dropDownTransSlide", OptionBox).selected = true;
			}
			
			attachEvent("dropDownTransNone", Event.CHANGE, function(e) {
				if (getComponentAs("dropDownTransNone", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(List, "none");
				}
			});
			attachEvent("dropDownTransFade", Event.CHANGE, function(e) {
				if (getComponentAs("dropDownTransFade", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(List, "fade");
				}
			});
			attachEvent("dropDownTransSlide", Event.CHANGE, function(e) {
				if (getComponentAs("dropDownTransSlide", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(List, "slide");
				}
			});
		}
		
		{
			var popupsTrans:String = Toolkit.getTransitionForClass(Popup);
			if (popupsTrans == "none") {
				getComponentAs("popupsTransNone", OptionBox).selected = true;
			} else if (popupsTrans == "fade") {
				getComponentAs("popupsTransFade", OptionBox).selected = true;
			} else if (popupsTrans == "slide") {
				getComponentAs("popupsTransSlide", OptionBox).selected = true;
			}
			
			attachEvent("popupsTransNone", Event.CHANGE, function(e) {
				if (getComponentAs("popupsTransNone", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Popup, "none");
				}
			});
			attachEvent("popupsTransFade", Event.CHANGE, function(e) {
				if (getComponentAs("popupsTransFade", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Popup, "fade");
				}
			});
			attachEvent("popupsTransSlide", Event.CHANGE, function(e) {
				if (getComponentAs("popupsTransSlide", OptionBox).selected == true) {
					Toolkit.setTransitionForClass(Popup, "slide");
				}
			});
		}
		
		{
			attachEvent("codeAsync", MouseEvent.CLICK, function(e:Event) {
				getComponentAs("code", Code).async = getComponentAs("codeAsync", CheckBox).selected;
			});
		}
		
		{
			_callers = new Map<ListViewItem, AsyncThreadCaller>();
			attachEvent("createRunner", MouseEvent.CLICK, _createRunner);
			attachEvent("runnerList", ListViewEvent.COMPONENT_EVENT, function(e:ListViewEvent) {
				var list:ListView = getComponentAs("runnerList", ListView);
				var listItem:ListViewItem = e.item;
				var caller:AsyncThreadCaller = cast(_callers.get(listItem) , AsyncThreadCaller);
				caller.cancel();
				var index:Int = list.getItemIndex(listItem);
				var n:Int = 0;
				if (list.dataSource.moveFirst()) {
					do {
						if (n == index) {
							list.dataSource.remove();
							break;
						}
						n++;
					} while (list.dataSource.moveNext());
				}
			});
		}
		
		{
			attachEvent("resizeOrg", MouseEvent.CLICK, function(e) {
				getComponent("image1").width = 165;
				getComponent("image1").height = 124;
				getComponent("image2").width = 165;
				getComponent("image2").height = 124;
			});
			attachEvent("resizeBigger", MouseEvent.CLICK, function(e) {
				getComponent("image1").width = 165 * 2;
				getComponent("image1").height = 124 * 2;
				getComponent("image2").width = 165 * 2;
				getComponent("image2").height = 124 * 2;
			});
		}
	}
	
	private var _callers:Map<ListViewItem, AsyncThreadCaller>;
	private function _createRunner(e:Event):Void {
		var list:ListView = getComponentAs("runnerList", ListView);
		var name:String = "Runner_" + list.listSize;
		list.dataSource.add( { text: name + ": 0", type: "button", value: "Cancel"  } );
		var item:ListViewItem = list.getItem(list.listSize - 1);
		
		var runner:DemoRunner = new DemoRunner(name, item, Std.parseFloat(getComponent("runnnerTimeshare").text));
		var caller:AsyncThreadCaller = new AsyncThreadCaller(runner);
		caller.addEventListener(ProgressEvent.PROGRESS, _onRunnerProgress);
		_callers.set(item, caller);
		caller.start();
	}
	
	private function _onRunnerProgress(event:ProgressEvent):Void {
		var caller:AsyncThreadCaller = cast(event.target, AsyncThreadCaller);
		var runner:DemoRunner = cast(caller.worker, DemoRunner);
		runner.listItem.text = runner.name + ": " + runner.counter;
	}
}

private class DemoRunner extends Runner {
	public var counter:Int = 0;
	public var name:String;
	public var listItem:ListViewItem;
	public function new(name:String, listItem:ListViewItem, timeshare:Float = .1):Void {
		super();
		this.name = name;
		this.listItem = listItem;
		_runningTimeShare = timeshare;
	}
	
	public override function run() {
		while (_needToExit() == false) {
			counter++;
			//trace(_counter);
		}
	}
}