﻿/*******************************************************************************
 * Copyright (c) iSpring Solutions, Inc. 
 * All rights reserved. This source code and the accompanying materials are made
 * available under the terms of the iSpring Public License v1.0 which accompanies
 * this distribution, and is available at:
 * http://www.ispringsolutions.com/legal/public-license-v10.html
 *
 *******************************************************************************/

package ispring.presenter.presentation.resources.references
{

/**
 * The ReferenceType class is an enumeration class that provides values for
 * the <code>type</code> property of the IReference interface.
 * 
 * @see ispring.presenter.presentation.resources.references.IReference#type
 * 
 * @langversion 3.0
 * @playerversion Flash 10.1
 * @productversion iSpring&nbsp;Pro 6.0.3
 * @productversion iSpring&nbsp;Platform 6.0
 */
public class ReferenceType 
{
	/**
	 * Indicates that the reference is a web link.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10.1
	 * @productversion iSpring&nbsp;Pro 6.0.3
	 * @productversion iSpring&nbsp;Platform 6.0
	 */
	public static const WEB_LINK:String = "webLink";


	/**
	 * Indicates that the reference is a file attachment.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10.1
	 * @productversion iSpring&nbsp;Pro 6.0.3
	 * @productversion iSpring&nbsp;Platform 6.0
	 */
	public static const ATTACHMENT:String = "attachment";
}

}