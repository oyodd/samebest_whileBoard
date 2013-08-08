/*******************************************************************************
 * Copyright (c) iSpring Solutions, Inc. 
 * All rights reserved. This source code and the accompanying materials are made
 * available under the terms of the iSpring Public License v1.0 which accompanies
 * this distribution, and is available at:
 * http://www.ispringsolutions.com/legal/public-license-v10.html
 *
 *******************************************************************************/

package ispring.presenter.player.events 
{

import flash.events.Event;

public class SharedAssetsLibraryEvent extends Event 
{
	public static const SLIDE_ASSETS_READY:String = "slideAssetsReady";
	
	private var m_slideIndex:Number;
		
	public function SharedAssetsLibraryEvent(type:String, slideIndex:Number) 
	{ 
		super(type, true);
		
		m_slideIndex = slideIndex;
	} 
	
	public function get slideIndex():Number
	{
		return m_slideIndex;
	}
	
	/**
	 * @private
	 */
	public override function clone():Event 
	{ 
		return new SharedAssetsLibraryEvent(type, slideIndex);
	} 
	
	/**
	 * @private
	 */
	public override function toString():String 
	{ 
		return formatToString("SharedAssetsLibraryEvent", "type", "bubbles", "cancelable", "eventPhase"); 
	}
}
	
}