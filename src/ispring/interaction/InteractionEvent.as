﻿/*******************************************************************************
 * Copyright (c) iSpring Solutions, Inc. 
 * All rights reserved. This source code and the accompanying materials are made
 * available under the terms of the iSpring Public License v1.0 which accompanies
 * this distribution, and is available at:
 * http://www.ispringsolutions.com/legal/public-license-v10.html
 *
 *******************************************************************************/

package ispring.interaction 
{

import flash.events.Event;
	
/**
 * The InteractionEvent class represents an event that is dispatched
 * by an object implementing the IInteraction interface.
 * 
 * @see ispring.interaction.IInteraction
 * 
 * @langversion 3.0
 * @playerversion Flash 10.1
 * @productversion iSpring&nbsp;Kinetics 6.0.3
 */
public class InteractionEvent extends Event 
{
	/**
	 * The <code>InteractionEvent.INIT</code> constant defines the value of the <code>type</code>
	 * property of the event object for a <code>interactionInitialized</code> event.
	 * 
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 *	<tr><th>Property</th>					<th>Value</th></tr>
	 *	<tr><td><code>bubbles</code></td>		<td><code>false</code></td></tr>
	 *	<tr><td><code>cancelable</code></td>	<td><code>false</code></td></tr>
	 *	<tr><td><code>currentTarget</code></td>	<td>The Object that defines the event listener that handles the event. For example, if you use <code>myButton.addEventListener()</code> to register an event listener, <code>myButton</code> is the value of the <code>currentTarget</code>.</td></tr>
	 *	<tr><td><code>target</code></td>		<td>The Object that dispatched the event; it is not always the Object listening for the event. Use the <code>currentTarget</code> property to always access the Object listening for the event.</td></tr>
	 * </table>
	 * 
	 * @eventType interactionInitialized
	 * 
	 * @see ispring.interaction.IInteraction#event:interactionInitialized
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10.1
	 * @productversion iSpring&nbsp;Kinetics 6.0.3
	 */
	public static const INIT:String = "interactionInitialized";
	public static const CONTENT_LOADED:String = "interactionContentLoaded";
	
	/**
	 * Constructor.
	 * 
	 * @param type The event type; indicates the action that triggered the event.
	 * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
	 * @param cancelable Specifies whether the behavior associated with the event can be prevented.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10.1
	 * @productversion iSpring&nbsp;Kinetics 6.0.3
	 */
	public function InteractionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
	{ 
		super(type, bubbles, cancelable);
	} 
	
	/**
	 * @private
	 */
	public override function clone():Event 
	{ 
		return new InteractionEvent(type, bubbles, cancelable);
	} 
	
	/**
	 * @private
	 */
	public override function toString():String 
	{ 
		return formatToString("InteractionEvent", "type", "bubbles", "cancelable", "eventPhase"); 
	}
}
	
}