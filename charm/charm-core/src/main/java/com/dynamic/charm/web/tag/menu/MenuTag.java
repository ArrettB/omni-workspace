/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: MenuTag.java 199 2006-11-14 23:38:41Z gcase $

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

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;

import org.apache.log4j.Logger;
import org.springframework.util.StringUtils;

import com.dynamic.charm.common.ArrayUtils;
import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.service.MenuService;
import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.SpringAwareTag;


/**
 * Generates a menu with the given identifier, using the MenuService
 *
 * <pre>
 * &lt;charm:menu code=&quot;main_menu&quot; &gt;
 *       &lt;charm:menuitem display=&quot;Logout&quot; display=&quot;logout.html&quot; /&gt;
 * &lt;/charm:menu&gt;
 * </pre>
 *
 * @jsp.tag name="menu" body-content="JSP" display-name="Menu Tag" description="Generates a menu
 *          with the given identifier, using the MenuService"
 *
 * @see com.dynamic.charm.web.tag.menu.MenuRenderer
 * @see com.dynamic.charm.web.tag.menu.MenuItemTag
 * @author gcase
 */
public class MenuTag extends SpringAwareTag implements MenuParent
{
    private final static Logger logger = Logger.getLogger(MenuTag.class);

    private String renderer;
    private String code;
    private String stickyParameters;

    private List _menuItems;
    private String _title;
    private String _href;

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        renderer = evalTool.evaluateAsString("renderer", renderer);
        code = evalTool.evaluateAsString("code", code);
        stickyParameters = evalTool.evaluateAsString("stickyParameters", stickyParameters);
    }

    protected int doStartTagInternal() throws Exception
    {
        MenuService menuService = (MenuService) getApplicationContext().getBean(MenuService.DEFAULT_MENU_SERVICE_NAME, MenuService.class);

        Menu menu = menuService.getMenu(code, getRequest());
        MenuItem[] items = menu.getMenuItems();
        _menuItems = new ArrayList(items.length);
        for (int i = 0; i < items.length; i++)
        {
            _menuItems.add(items[i]);
        }

        _title = menu.getTitle();
        _href = menu.getHref();

        return EVAL_BODY_INCLUDE;
    }

    public String getActiveMenuCode()
    {
        String selectedMenu = getParameter(MenuRenderer.SELECTED_MENU_ITEM_ATTR);

        if (StringUtils.hasText(selectedMenu))
        {
            setSessionAttribute(MenuRenderer.SELECTED_MENU_ITEM_ATTR, selectedMenu);
        }

        return (String) getSessionAttribute(MenuRenderer.SELECTED_MENU_ITEM_ATTR);
    }

    public int doEndTagInternal()
    {
        Collections.sort(_menuItems);

        // convert to array
        MenuItem[] items = (MenuItem[]) ArrayUtils.toArray(_menuItems, MenuItem.class);

        // determine active item
        String active = getActiveMenuCode();
        if (active != null)
        {
            for (int i = 0; i < items.length; i++)
            {
                if (active.equals(items[i].getCode()))
                {
                    items[i].setActive(true);
                    break;
                }
            }
        }

        String rendererName = renderer;
        if (rendererName == null)
        {
            rendererName = getPrefixedMessage(MenuTag.class, "renderer");
        }

        try
        {
            Class rendererClass = Class.forName(rendererName);
            MenuRenderer menuRenderer;
            menuRenderer = (MenuRenderer) rendererClass.newInstance();

            if (stickyParameters != null)
            {
                String[] stickyParams = stickyParameters.split(",");
                menuRenderer.setStickyParameters(stickyParams);
            }

            menuRenderer.setContextPath(getRequestContext().getContextPath());
            menuRenderer.setLocale(getRequestContext().getLocale());
            menuRenderer.setRequestContext(getRequestContext());
            menuRenderer.setPageContext(pageContext);
            menuRenderer.setMenuTitle(_title);
            menuRenderer.setMenuTitleHref(_href);
            menuRenderer.setMenuItems(items);
            write(menuRenderer.render());
        }
        catch (ClassNotFoundException e)
        {
            throw new CharmException("Could not find renderer class for " + rendererName, e);
        }
        catch (InstantiationException e)
        {
            throw new CharmException("InstantiationException using renderer class for " +
                rendererName, e);
        }
        catch (IllegalAccessException e)
        {
            throw new CharmException("IllegalAccessException using renderer class for " +
                rendererName, e);
        }

        return BodyTag.EVAL_PAGE;
    }

    public void addMenuItem(MenuItem item)
    {
        _menuItems.add(item);
    }

    public int getMenuItemCount()
    {
        return _menuItems.size();
    }

    public void release()
    {
        super.release();
        if (_menuItems != null)
        {
            _menuItems.clear();
        }
        _menuItems = null;
    }

    /**
     * Returns the code
     *
     * @return current value of code
     * @jsp.attribute required="true" rtexprvalue="true" description="The
     *                identifier to be used when retrieving the menu items for
     *                this menu"
     */
    public String getCode()
    {
        return code;
    }

    public void setCode(String code)
    {
        this.code = code;
    }

    /**
     * Returns the renderer
     *
     * @return current value of renderer
     * @jsp.attribute required="false" rtexprvalue="true" description="The fully
     *                qualified classname that should be used to render the
     *                menuItem. The class must implement MenuRenderer"
     */
    public String getRenderer()
    {
        return renderer;
    }

    public void setRenderer(String renderer)
    {
        this.renderer = renderer;
    }

    /**
     * Returns the stickyParameters
     *
     * @return current value of stickyParameters
     * @jsp.attribute required="false" rtexprvalue="true" description="A comma separated list of parameters that should be included everytime the menu displays"
     */
    public String getStickyParameters()
    {
        return stickyParameters;
    }

    public void setStickyParameters(String stickyParameters)
    {
        this.stickyParameters = stickyParameters;
    }
}
