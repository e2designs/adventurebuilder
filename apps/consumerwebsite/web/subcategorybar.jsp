<%-- Copyright 2004 Sun Microsystems, Inc.  All rights reserved.  You may not modify, use, reproduce, or distribute this software except in compliance with the terms of the License at: 
 http://adventurebuilder.dev.java.net/LICENSE.txt
 $Id: subcategorybar.jsp,v 1.5 2005/02/04 20:06:13 yutayoshida Exp $ --%>
<%@ taglib prefix="sql" uri="/WEB-INF/sql.tld" %>
<%@ taglib prefix="c" uri="/WEB-INF/c.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/fn.tld" %>
<%@page contentType="text/html"%>
<%@ taglib uri="/WEB-INF/waftags.tld" prefix="waf" %>

<sql:setDataSource dataSource="jdbc/CatalogDB"/>

<%-- Need to set the category id  --%>
 <c:choose>
  <c:when test="${param.CATEGORY_ID  != null}">
   <c:set var="theCategory" value="${param.CATEGORY_ID}" scope="session"/>
   <c:set var="categoryId" value="${param.CATEGORY_ID}" scope="session"/>
  </c:when>
  <c:otherwise>
   <c:set var="theCategory" value="${categoryId}" scope="session"/>
  </c:otherwise>
 </c:choose>

<sql:query var="categories"> 
 select catid,name,description from category where locale = ? order by name
 <sql:param>en_US</sql:param>
</sql:query>

<table  cellspacing="12" cellpadding="12" border="0">

 <tr>
    <td  align="left" nowrap="nowrap" bgcolor="#ffffff">
       <strong class="navigationTitle">Adventure Categories</strong>
    </td>
   </tr>
   <tr>
    <td nowrap="nowrap">

         <c:forEach var="category" begin="0" items="${categories.rows}">
          <c:url value="/adventures.screen" var="viewCategoryURL">
          <c:param name="CATEGORY_ID" value="${fn:trim(category.catid)}"/>
         </c:url>

          <p class="navigation">
            <c:choose>
             <c:when test="${param.CATEGORY_ID == fn:trim(category.catid)}">
                <image src="images/Arrow_small.gif" width="10" height="14" alt="Selected Arrow Image">
             </c:when>
             <c:otherwise>
               <image src="images/Arrow_spacer.gif" alt="">
             </c:otherwise>
            </c:choose>
           <a href="${viewCategoryURL}">${category.name}</a>
          </p>
          <c:choose>
           <%-- List the Sub Category Stuff here --%>
           <c:when test="${fn:trim(category.catid) == theCategory}">

             <!-- sql should be executed only when the category id is set -->
             <sql:query var="packages"> 
              select distinct package.packageid, package.name as pname,
                       category.name  as cname, category.catid 
                  from  package, category
                  where package.catid=? and category.catid = ? and package.locale = ?
              <sql:param>${theCategory}</sql:param>
              <sql:param>${theCategory}</sql:param>
              <sql:param>en_US</sql:param>
             </sql:query>

            <c:forEach var="package" begin="0" items="${packages.rows}">
            <p class="sub_navigation">
             <c:url value="/adventure.screen" var="viewPackageURL">
              <c:param name="PACKAGE_ID" value="${fn:trim(package.packageid)}"/>
             </c:url>
             &nbsp;&nbsp;&nbsp;
            <c:choose>
             <%-- Identify a selected Adventure Package --%>
             <c:when test="${param.PACKAGE_ID == fn:trim(package.packageid)}">
                <image src="images/Arrow_small.gif" alt="Selected Arrow Image">
             </c:when>
             <c:otherwise>
               <image src="images/Arrow_spacer.gif" alt="">
             </c:otherwise>
            </c:choose>
            <a href="${viewPackageURL}">${package.pname}</a>
             </p>
            </c:forEach>
           </c:when>
           <%-- Done Listing the Sub Category Stuff here --%>
          </c:choose>
       </c:forEach>
       </td>
     </tr>
   </table>


