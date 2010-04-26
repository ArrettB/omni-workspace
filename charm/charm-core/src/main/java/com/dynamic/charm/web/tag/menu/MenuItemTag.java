/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: MenuItemTag.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.tag.menu;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.BodyTag;

import org.apache.taglibs.standard.resources.Resources;

import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.SpringAwareTag;


/**
 * Generates a menu with the given identifier, using the MenuService
 *
 * <pre>
 * &lt;charm:menu code=&quot;main_menu&quot; &gt;
 *        &lt;charm:menuitem display=&quot;Logout&quot; display=&quot;logout.html&quot; /&gt;
 * &lt;/charm:menu&gt;
 * </pre>
 *
 * @jsp.tag name="menuitem" body-content="empty" display-name="Menu Item Tag" description="Generates a a menu item that will be placed in the parent menu.  Can support nested menu items"
 *
 * @see com.dynamic.charm.web.tag.menu.MenuRenderer
 * @see com.dynamic.charm.web.tag.menu.MenuItemTag
 * @author gcase
 */
public class MenuItemTag extends SpringAwareTag implements MenuParent
{
    private String display;
    private String href;
    private String displayOrderExpr;
    private Integer displayOrder;
    private String target;

    private MenuItem _menuItem;

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        display = evalTool.evaluateAsString("display", display);
        href = evalTool.evaluateAsString("href", href);
        displayOrder = new Integer(evalTool.evaluateAsInteger("displayOrder", displayOrderExpr));
        target = evalTool.evaluateAsString("target", target);
    }

    protected int doStartTagInternal() throws Exception
    {
        MenuParent parent = (MenuParent) findAncestorWithClass(this, MenuParent.class);
        if (parent == null)
        {
            throw new JspTagException(Resources.getMessage("PARAM_OUTSIDE_PARENT"));
        }

        _menuItem = new MenuItem();
        _menuItem.setDisplay(display);
        _menuItem.setHref(href);
        if (displayOrder == null)
        {
            _menuItem.setDisplayOrder(parent.getMenuItemCount() + 1);
        }
        else
        {
            _menuItem.setDisplayOrder(displayOrder.intValue());
        }
        _menuItem.setTarget(target);
        parent.addMenuItem(_menuItem);

        return EVAL_BODY_INCLUDE;
    }

    protected int doEndTagInternal()
    {
    	return BodyTag.EVAL_PAGE;
    }    
    
    public void release()
    {
        super.release();
        _menuItem = null;
    }

    public void addMenuItem(MenuItem item)
    {
        _menuItem.addMenuItem(item);
    }

    /**
     * Returns the code
     *
     * @return current value of code
     * @jsp.attribute required="true" rtexprvalue="true" description="The text that should be displayed for the menu item.  Can also refer to a code to be looked up in the messageResources"
     */
    public String getDisplay()
    {
        return display;
    }

    public void setDisplay(String display)
    {
        this.display = display;
    }

    /**
     * Returns the displayOrder
     *
     * @return current value of displayOrder
     * @jsp.attribute required="false" rtexprvalue="true" description="The order that this menu item should be displayed in"
     */
    public String getDisplayOrder()
    {
        return displayOrderExpr;
    }

    public void setDisplayOrder(String displayOrder)
    {
        this.displayOrderExpr = displayOrder;
    }

    /**
     * Returns the getHref
     *
     * @return current value of getHref
     * @jsp.attribute required="true" rtexprvalue="true" description="The href to use when the user clicks on the item"
     */
    public String getHref()
    {
        return href;
    }

    public void setHref(String href)
    {
        this.href = href;
    }

    /**
     * Returns the target
     *
     * @return current value of code
     * @jsp.attribute required="false" rtexprvalue="true" description="The target of the href"
     */
    public String getTarget()
    {
        return target;
    }

    public void setTarget(String target)
    {
        this.target = target;
    }

    public int getMenuItemCount()
    {
        return _menuItem.getMenuItems().length;
    }
}
