/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: MenuItem.java 199 2006-11-14 23:38:41Z gcase $

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
import java.util.Iterator;
import java.util.List;

import com.dynamic.charm.common.ArrayUtils;


/**
 *
 * @author gcase
 */
public class MenuItem implements Comparable
{
    private String code;
    private String display;
    private String target;
    private String href;
    private int displayOrder;

    private boolean active = false;
    private List menuItems = new ArrayList();

    public MenuItem()
    {
    }

    public MenuItem(String code, String display, String href)
    {
        this(code, display, href, 0, null);
    }

    public MenuItem(String code, String display, String href, Integer displayOrder)
    {
        this(code, display, href, displayOrder.intValue(), null);
    }

    public MenuItem(String code, String display, String href, int displayOrder)
    {
        this(code, display, href, displayOrder, null);
    }

    public MenuItem(String code, String display, String href, int displayOrder, String target)
    {
        this.code = code;
        this.display = display;
        this.href = href;
        this.displayOrder = displayOrder;
        this.target = target;
    }

    public void addMenuItem(MenuItem item)
    {
        menuItems.add(item);
    }

    public MenuItem[] getMenuItems()
    {
        return (MenuItem[]) ArrayUtils.toArray(menuItems, MenuItem.class);
    }

    public int compareTo(Object o)
    {
        if (o instanceof MenuItem)
        {
            MenuItem rhs = (MenuItem) o;
            return this.displayOrder - rhs.displayOrder;
        }
        return 0;
    }

    public String getCode()
    {
        return code;
    }

    public void setCode(String code)
    {
        this.code = code;
    }

    public String getDisplay()
    {
        return display;
    }

    public void setDisplay(String display)
    {
        this.display = display;
    }

    public int getDisplayOrder()
    {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder)
    {
        this.displayOrder = displayOrder;
    }

    public String getHref()
    {
        return href;
    }

    public void setHref(String href)
    {
        this.href = href;
    }

    public String getTarget()
    {
        return target;
    }

    public void setTarget(String target)
    {
        this.target = target;
    }

    public boolean isActive()
    {
        return active;
    }

    public void setActive(boolean active)
    {
        this.active = active;
    }

    public boolean isChildActive()
    {
        for (Iterator iter = menuItems.iterator(); iter.hasNext();)
        {
            MenuItem item = (MenuItem) iter.next();
            if (item.isActive())
            {
                return true;
            }
        }
        return false;
    }

    public boolean hasChildren()
    {
        return menuItems.size() > 0;
    }
    
	public String toString()
	{
		return "[MenuItem] - " + code + " - " + display;
	}
}
