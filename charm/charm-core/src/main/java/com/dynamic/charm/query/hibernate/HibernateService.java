/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: HibernateService.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.query.hibernate;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.hibernate.SessionFactory;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;

import com.dynamic.charm.query.DataService;


public interface HibernateService extends DataService
{
    public HibernateTemplate getHibernateTemplate();

    public SessionFactory getSessionFactory();

    public void setSessionFactory(SessionFactory sessionFactory);

    public Object get(Class entityClass, Serializable id);

    public Object load(Class entityClass, Serializable id);

    public Object save(Object instance);

    public Object update(Object instance);

    public Object saveOrUpdate(Object instance);

    public void delete(Object instance);

    public Object merge(Object instance);

    public void deleteAll(Collection entities);

    public List findAll(Class entityClass);

    public Object execute(HibernateCallback callback);

    public boolean isNewObject(Class entityClass, Object instance);

    /**
     * Need to pass the class in, since the actual runtime type of the class may
     * be different than expected (due to proxies needed for lazy loading)
     *
     * @param entityClass
     * @param object
     * @return
     */
    public Serializable getIdentifier(Class entityClass, Object object);

    public String getIdentifierName(Class entityClass);

    public boolean supports(Class entityClass);

    public String resolveClassName(String className);

    public Class resolveClass(String classname) throws ClassNotFoundException;

    /**
     * The default package is the package name that will be prepended to the
     * classname provided whenenever the resolveClass() method is called.
     *
     * @see resolveClass
     */
    public String getDefaultPackage();

    public void setDefaultPackage(String defaultPackage);

    void saveOrUpdateAll(Collection collection);
}
