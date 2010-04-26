/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: DefaultMenuRenderer.java 199 2006-11-14 23:38:41Z gcase $

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

import com.dynamic.charm.web.builder.HTMLElement;


/**
 * This is designed to render a menu using nested <code>&lt;ul&gt;</code> and <code>&lt;lu&gt;</code> elements.
 *
 * <pre>
&lt;div id=&quot;menu&quot;&gt;
  &lt;ul&gt;
    &lt;li&gt;
      &lt;h2&gt;[Navigation Menu]&lt;/h2&gt;
      &lt;ul&gt;
        &lt;li&gt;
          &lt;a href=&quot;/bbp/public/user_home.html?__mi=user_home&quot;&gt;My BizBidPlace&lt;/a&gt;
        &lt;/li&gt;
        &lt;li&gt;
          &lt;a href=&quot;/bbp/public/calendar.html?__mi=calendar&quot;&gt;Auction Calendar&lt;/a&gt;
        &lt;/li&gt;
        &lt;li class=&quot;selected&quot;&gt;
          &lt;a href=&quot;/bbp/search_results.html?__mi=search&quot;&gt;Auction Search&lt;/a&gt;
        &lt;/li&gt;
      &lt;/ul&gt;
    &lt;/li&gt;
  &lt;/ul&gt;
&lt;/div&gt;
 * </pre>
 *
 * @author gcase
 *
 */
public class DefaultMenuRenderer extends AbstractMenuRenderer implements MenuRenderer
{
    public String render()
    {
        HTMLElement root = HTMLElement.createRootElement();

        HTMLElement div = root.createElement("div");
        div.id("menu");

        //our top level unordered list
        HTMLElement ul = div.createElement("ul");

        //create the menu title inside of its own list item
        HTMLElement li = ul.createElement("li");
        HTMLElement h2 = li.createElement("h2");
        h2.setText(menuTitle);

        ul = li.createElement("ul");

        renderChildren(ul, menuItems);

        return div.evaluate();
    }

    public void renderChildren(HTMLElement ulElement, MenuItem[] children)
    {
        for (int i = 0; i < children.length; i++)
        {
            MenuItem item = children[i];
            HTMLElement li = ulElement.createElement("li");
            HTMLElement anchor = createAnchorElement(item, li);

            if (item.isActive())
            {
                li.css("selected");
            }

            if (item.hasChildren())
            {
                HTMLElement parentUl = li.createElement("ul");
                renderChildren(parentUl, item.getMenuItems());
            }
        }
    }
}
