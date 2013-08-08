/*******************************************************************************
 * Copyright (c) iSpring Solutions, Inc. 
 * All rights reserved. This source code and the accompanying materials are made
 * available under the terms of the iSpring Public License v1.0 which accompanies
 * this distribution, and is available at:
 * http://www.ispringsolutions.com/legal/public-license-v10.html
 *
 *******************************************************************************/

package ispring.presenter.presentation
{
	
/**
 * The ITimestamp interface provides information about the position within the presentation.
 * 
 * @see ispring.presenter.player.clock.IPresentationClock
 * @see ispring.presenter.presentation.narration.INarrationTrack
 * @see ispring.presenter.presentation.slides.ISlides#convertTimestampToTime()
 * @see ispring.presenter.presentation.slides.ISlides#convertTimeToTimestamp()
 * 
 * @langversion 3.0
 * @playerversion Flash 10.1
 * @productversion iSpring&nbsp;Pro 6.0.3
 * @productversion iSpring&nbsp;Platform 6.0
 */
public interface ITimestamp
{
	/**
	 * The index of the slide.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10.1
	 * @productversion iSpring&nbsp;Pro 6.0.3
	 * @productversion iSpring&nbsp;Platform 6.0
	 */
	function get slideIndex():uint;
	
	/**
	 * The animation step index. If the <code>stepIndex</code> property 
	 * is equal to <code>-1</code> it is considered to be a slide transition effect phase.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10.1
	 * @productversion iSpring&nbsp;Pro 6.0.3
	 * @productversion iSpring&nbsp;Platform 6.0
	 */
	function get stepIndex():int;
	
	/**
	 * A time offset from the beginning of the animation step, in seconds.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10.1
	 * @productversion iSpring&nbsp;Pro 6.0.3
	 * @productversion iSpring&nbsp;Platform 6.0
	 */
	function get timeOffset():Number;
}
	
}
