/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: AnchorElement.java 199 2006-11-14 23:38:41Z gcase $

* THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
* OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
* BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
* SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
* LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
* USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
* OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
* SUCH DAMAGE.
* ====================================================================
*/


package com.dynamic.charm.web.builder;

import org.dom4j.Element;


public class AnchorElement extends HTMLElement
{
    private HrefBuilder builder;

    public AnchorElement(Element parent)
    {
        super(parent, "a");
    }

    public AnchorElement href(String href)
    {
        this.builder = new HrefBuilder(href);
		setAttribute("href", builder.evaluate());
        return this;
    }

    public AnchorElement href(HrefBuilder builder)
    {
        this.builder = builder;
		setAttribute("href", builder.evaluate());
        return this;
    }

    public void addParameter(String parameterName, String parameterValue)
    {
        if (builder == null)
        {
            builder = new HrefBuilder("");
        }
        builder.addParameter(parameterName, parameterValue);
		setAttribute("href", builder.evaluate());
    }

    public String evaluate()
    {
 //   	if (builder != null)
   // 		setAttribute("href", builder.evaluate());
    	return super.evaluate();
    }
    
}
