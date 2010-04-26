/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: HTMLElement.java 199 2006-11-14 23:38:41Z gcase $

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

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.util.Iterator;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.HTMLWriter;
import org.dom4j.io.OutputFormat;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class HTMLElement
{
    protected Element delegate;

    private HTMLElement(Element delegate)
    {
        this.delegate = delegate;
    }

    public HTMLElement(Element parent, String elementName)
    {
        delegate = parent.addElement(elementName);
    }

    public static HTMLElement createRootElement()
    {
        return createRootElement("root");
    }

    public static HTMLElement createRootElement(String rootName)
    {
        Document document = DocumentHelper.createDocument();
        Element root = document.addElement(rootName);
        return new HTMLElement(root);
    }

    public HTMLElement createElement(String name)
    {
        HTMLElement result = new HTMLElement(delegate, name.toLowerCase());
        return result;
    }

    public HTMLElement addComment(String comment)
    {
        delegate.addComment(comment);
        return this;
    }

    public HTMLElement addContent(HTMLElement element)
    {
        delegate.add(element.delegate);
        return this;
    }

    /**
     * Adds the attribute to the element.  Note: the attribute name will be converted to lowercase.
     *
     * @param attributeName the name of the attribute
     * @param value the value of the attribute
     * @return the original HTMLElement, to support method chaining
     */
    public HTMLElement setAttribute(String attributeName, String value)
    {
        if (value != null)
        {
            delegate.addAttribute(attributeName.toLowerCase(), value);
        }
        return this;
    }

    public HTMLElement setAttribute(String attributeName, int value)
    {
        return this.setAttribute(attributeName, Integer.toString(value));
    }

    public HTMLElement setAttribute(String attributeName, boolean value)
    {
        return this.setAttribute(attributeName, Boolean.toString(value));
    }

    public HTMLElement setText(String text)
    {
        if (text != null)
        {
            delegate.setText(text);
        }
        return this;
    }

    public HTMLElement style(String style)
    {
        return this.setAttribute("style", style);
    }

    public HTMLElement css(String cssClass)
    {
        return this.setAttribute("class", cssClass);
    }

    public HTMLElement id(String id)
    {
        return this.setAttribute("id", id);
    }

    public TableElement createTableElement()
    {
        TableElement result = new TableElement(delegate);
        return result;
    }

    public FormElement createFormElement(String name, String method)
    {
        FormElement result = new FormElement(delegate);
        result.name(name);
        result.method(method);
        return result;
    }

    public ImageElement createImageElement(String src)
    {
        ImageElement result = new ImageElement(delegate);
        result.src(src);
        return result;
    }

    public AnchorElement createAnchorElement(String display, String href)
    {
        AnchorElement result = new AnchorElement(delegate);
        result.href(href);
        result.setText(display);
        return result;
    }

    public AnchorElement createAnchorElement(String display, HrefBuilder builder)
    {
        AnchorElement result = new AnchorElement(delegate);
        result.href(builder);
        result.setText(display);
        return result;
    }

    public DivElement createDivElement(String id)
    {
    	DivElement div = new DivElement(delegate);
        div.setAttribute("id", id);
        return div;
    }
    
    public SelectElement createSelectElement(String name)
    {
        SelectElement result = new SelectElement(delegate);
        result.name(name);
        return result;
    }

    public RadioGroupElement createRadioGroupElement(String name)
    {
        RadioGroupElement result = new RadioGroupElement(delegate);
        result.name(name);
        return result;
    }

    public InputElement createInputElement(String type, String name)
    {
        return createInputElement(type, name, null);
    }

    public InputElement createInputElement(String type, String name, String value)
    {
        InputElement result = new InputElement(delegate);
        result.type(type);
        result.name(name);
        result.value(value);
        return result;
    }

    public InputElement createInputElementText(String name, String value)
    {
        return createInputElement("text", name, value);
    }

    public InputElement createInputElementHidden(String name, String value)
    {
        return createInputElement("hidden", name, value);
    }

    public InputElement createInputElementButton(String name, String value)
    {
        return createInputElement("button", name, value);
    }

    public InputElement createInputElementFile(String name)
    {
        return createInputElement("file", name);
    }

    public InputElement createInputElementSubmit(String name, String value)
    {
        return createInputElement("submit", name, value);
    }

    public InputElement createInputElementPassword(String name, String value)
    {
        return createInputElement("password", name, value);
    }

    public InputElement createInputElementRadio(String name, String value)
    {
        return createInputElement("radio", name, value);
    }

    public InputElement createInputElementCheckbox(String name)
    {
        return createInputElement("checkbox", name);
    }

    public TextAreaElement createTextAreaElement(String name)
    {
        TextAreaElement result = new TextAreaElement(delegate);
        result.setAttribute("name", name);
        return result;
    }

    public UnorderedListElement createUnorderedListElement()
    {
        UnorderedListElement result = new UnorderedListElement(delegate);
        return result;
    }

    public String evaluate()
    {
        try
        {
            StringWriter writer = new StringWriter();
            HTMLWriter htmlWriter = new HTMLWriter(new PrintWriter(writer), createOutputFormat());
            htmlWriter.write(delegate);
            return writer.toString();
        }
        catch (UnsupportedEncodingException e)
        {
        }
        catch (IOException e)
        {
        }
        return null;
    }

    public String evaluateCompact()
    {
        try
        {
            StringWriter writer = new StringWriter();
            HTMLWriter htmlWriter = new HTMLWriter(new PrintWriter(writer), createCompactFormat());
            htmlWriter.write(delegate);
            return writer.toString();
        }
        catch (UnsupportedEncodingException e)
        {
        }
        catch (IOException e)
        {
        }
        return null;
    }
    
    public String evaluateChildren()
    {
        try
        {
            StringWriter writer = new StringWriter();
            HTMLWriter htmlWriter = new HTMLWriter(new PrintWriter(writer), createOutputFormat());
            for (Iterator iter = delegate.elementIterator(); iter.hasNext();)
            {
                htmlWriter.write(iter.next());
            }
            return writer.toString();
        }
        catch (UnsupportedEncodingException e)
        {
        }
        catch (IOException e)
        {
        }
        return null;
    }

    public String toString()
    {
        return evaluate();
    }

    public HTMLElement addJavascriptSrc(String src)
    {
        return addJavascript(null, src);
    }

    public HTMLElement addJavascript(String innerScriptText)
    {
        return addJavascript(innerScriptText, null);
    }

    public HTMLElement addText(String text)
    {
        delegate.addText(text);
        return this;
    }

    public HTMLElement addJavascript(String innerScriptText, String src)
    {
        HTMLElement result = new HTMLElement(delegate, "script");
        result.setAttribute("type", "text/javascript");
        result.setAttribute("src", src);
        result.setText(innerScriptText);
        return this;
    }

    public void addSpace()
    {
        delegate.addEntity("nbsp", " ");
    }

    public HTMLElement setSimpleAttribute(String attributeName, boolean isTrue)
    {
        if (isTrue)
        {
            this.setAttribute(attributeName, attributeName);
        }
        else
        {
            this.setAttribute(attributeName, null);
        }
        return this;
    }
    
    public HTMLElement setSimpleAttribute(String attributeName, String isTrue)
    {
      if (isTrue != null)
      {
    	  return setSimpleAttribute(attributeName, "true".equalsIgnoreCase(isTrue));
      }
      else
      {
    	  return setSimpleAttribute(attributeName, false);
      }
    }

    
    
    private static OutputFormat createOutputFormat()
    {
        OutputFormat format = OutputFormat.createPrettyPrint();
        format.setTrimText(false);
        format.setXHTML(true);
        format.setExpandEmptyElements(true);
        return format;
    }

    private static OutputFormat createCompactFormat()
    {
        OutputFormat format = OutputFormat.createCompactFormat();
        format.setTrimText(false);
        format.setXHTML(true);
        format.setExpandEmptyElements(true);
        format.setNewlines(false);
        return format;
    }    
    
    
    public static void main(String[] args)
    {
    	HTMLElement root  = HTMLElement.createRootElement();
    	HTMLElement anchor = root.createAnchorElement("Foobar", "#");
    	
		HTMLElement dummy  = HTMLElement.createRootElement();
		HTMLElement para = dummy.createElement("p");
		
		para.addText("This does not yet have any help text associated with it.   You can");
		para.createAnchorElement(" add the help content", "#");
		para.addText(" if you wish.");
		
		StringBuffer onMouseOver = new StringBuffer();
		onMouseOver.append("domTT_activate(this, event, ");
		onMouseOver.append("'caption', '" + "Title" + "', ");
		onMouseOver.append("'content', '" + para.evaluateCompact() + "', ");
		onMouseOver.append("'trail', 'x');");

		anchor.setAttribute("onMouseOver", onMouseOver.toString());
		
		System.out.println(root.evaluateCompact());
		
		
    }
}
