<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl  ="http://www.w3.org/1999/XSL/Transform"
	xmlns:date ="http://exslt.org/dates-and-times"
	xmlns:fn   ="http://www.w3.org/2005/xpath-functions"
	xmlns:saxon="http://icl.com/saxon"
	saxon:trace="true"
	extension-element-prefixes="saxon">
  <xsl:param name="tooltipLanguage"><xsl:text>English</xsl:text></xsl:param>
  <xsl:param name="version"><xsl:text>4.0</xsl:text></xsl:param>

<!-- TODO images for Volume nodes -->

<!--
Copyright (c) 2001-2022 held by the author(s).  All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer
      in the documentation and/or other materials provided with the
      distribution.
    * Neither the names of the Naval Postgraduate School (NPS)
      Modeling Virtual Environments and Simulation (MOVES) Institute
      (https://www.nps.edu and https://www.MovesInstitute.org)
      nor the names of its contributors may be used to endorse or
      promote products derived from this software without specific
      prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
-->

<!--
  <head>
   <meta name="filename"    content="X3dTooltipConversions.xslt" />
   <meta name="author"      content="Don Brutzman" />
   <meta name="created"     content="15 April 2002" />
   <meta name="revised"     content="6 May 2006" />
   <meta name="description" content="XSL stylesheet to build the X3D Tooltips (originally used for SIGGRAPH Online pages).  Additional HTML improvements by Juan Gril and Jeff Weekley." />
   <meta name="url"         content="https://www.web3d.org/x3d/tooltips/X3dTooltipConversions.xslt" />
  </head>

Recommended tools:
-  SAXON XML Toolkit (and Instant Saxon) from Michael Kay of ICL, http://saxon.sourceforge.net
   Especially necessary since this stylesheet uses saxon-specific extensions for file handling
-  XML Spy can be configured to use latest Saxon.  See README.txt in this directory.

Invocation:
-  cd   C:\www.web3d.org\x3d\content
   make tooltips
   (or)
   saxon -t -o X3dTooltips.html 	x3d-3.1.profile.xml X3dTooltipConversions.xslt

-->
	<xsl:strip-space elements="*"/>
        
        <!-- https://www.w3schools.com/tags/att_meta_charset.asp -->
        <!-- https://www.java.net/forum/topic/javadesktop/general-desktop-discussions/general-desktop-issues-discussion/javahelp-javaioioexception-cant-store-docu -->
        <!-- note UTF-8 is capitalized -->
        <xsl:output method="html" encoding="UTF-8" media-type="text/html" indent="yes"/>
	
	<xsl:variable name="x3dSpecificationUrlBase">
        <xsl:choose>
            <xsl:when test="starts-with($version, '3')">
                <xsl:text>https://www.web3d.org/documents/specifications/19775-1/V3.3</xsl:text>
                <!-- v3.3 includes bookmarks for each node in Node Index clause -->
                <!-- <xsl:text>https://www.web3d.org/documents/specifications/19775-1/V3.3</xsl:text> -->
                <!-- prior specification versions not used since less authoritative and (for 3.1) only include changes -->
                <!-- <xsl:text>https://www.web3d.org/documents/specifications/19775-1/V3.2/</xsl:text> -->
            </xsl:when>
            <xsl:otherwise>
                <!-- v4.0 includes bookmarks for each node in Node Index clause -->
                <xsl:text>https://www.web3d.org/specifications/X3Dv4Draft/ISO-IEC19775-1v4-DIS</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:variable>

        <!-- $schemaDocumentationUrl and $doctypeDocumentationUrl moved here by Hyokwang Lee -->
        <!-- https://www.web3d.org/specifications/X3dSchemaDocumentation3.3/x3d-3.3_Layer.html -->
        <xsl:variable name="schemaDocumentationUrl">
            <xsl:text>https://www.web3d.org/specifications/X3dSchemaDocumentation</xsl:text>
            <xsl:value-of select="$version"/>
            <xsl:text>/x3d-</xsl:text>
            <xsl:value-of select="$version"/>
            <xsl:text>.html</xsl:text>
        </xsl:variable>

        <!-- https://www.web3d.org/specifications/X3dDoctypeDocumentation3.3.html#AudioClip -->
        <xsl:variable name="doctypeDocumentationUrl">
            <xsl:text>https://www.web3d.org/specifications/X3dDoctypeDocumentation</xsl:text>
            <xsl:value-of select="$version"/>
            <xsl:text>.html</xsl:text>
        </xsl:variable>

        <!--          https://www.web3d.org/specifications/java/X3dJavaSceneAuthoringInterface.html -->
        <xsl:variable name="x3djsailUrl">
            <xsl:text>https://www.web3d.org/specifications/java/X3dJavaSceneAuthoringInterface.html</xsl:text>
        </xsl:variable>

        <!--          https://www.web3d.org/specifications/X3dJsonSchemaDocumentation3.3/x3d-3.3-JSONSchema.html#AudioClip -->
        <xsl:variable name="jsonDocumentationUrl">
            <xsl:text>https://www.web3d.org/specifications/X3dJsonSchemaDocumentation3.3/x3d-3.3-JSONSchema.html</xsl:text>
        </xsl:variable>
        
        <!-- https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeInterfaces.html#Anchor -->
        <xsl:variable name="javaSaiDocumentationUrl">
            <xsl:text>https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeInterfaces.html</xsl:text>
        </xsl:variable>
        
        <!--          https://www.web3d.org/specifications/java/javadoc/org/web3d/x3d/jsail/CADGeometry/CADAssembly.html -->
        <xsl:variable name="x3djsailDocumentationUrl">
            <xsl:text>https://www.web3d.org/specifications/java/javadoc/org/web3d/x3d/jsail/</xsl:text>
        </xsl:variable>
        
        <!--          https://www.web3d.org/specifications/X3dRegularExpressions.html#SFBool -->
        <xsl:variable name="x3dRegexUrl">
            <xsl:text>https://www.web3d.org/specifications/X3dRegularExpressions.html</xsl:text>
        </xsl:variable>
		
		<xsl:variable name="searchMantisUrl">
			<xsl:text>https://www.web3d.org/member-only/mantis/search.php?project_id=4&amp;search=</xsl:text>
			<xsl:value-of select="@name"/>
		</xsl:variable>
        
	<xsl:variable name="x3dSpecificationTop">
		<xsl:text>Part01/Architecture.html</xsl:text>
	</xsl:variable>
	<xsl:variable name="x3dSpecificationNodeIndex">
		<xsl:text>Part01/nodeIndex.html</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="pageName">
		<xsl:text>X3dTooltips</xsl:text>
		<xsl:if test="($tooltipLanguage != 'English')">
			<xsl:value-of select="$tooltipLanguage"/>
		</xsl:if>
		<xsl:text>.html</xsl:text>
	</xsl:variable>
        
        <xsl:variable name="pageUrl">
            <xsl:text>https://www.web3d.org/x3d/tooltips/X3dTooltips</xsl:text>
            <xsl:if test="($tooltipLanguage != 'English')">
                    <xsl:value-of select="$tooltipLanguage"/>
            </xsl:if>
            <xsl:if test="not($version='4.0') and ($tooltipLanguage = 'English')">
                <xsl:value-of select="$version"/>
            </xsl:if>
            <xsl:text>.html</xsl:text>
        </xsl:variable>

	<xsl:variable name="todaysDate">
		<xsl:value-of select="fn:day-from-date(current-date())"/>
		<xsl:text> </xsl:text>
                <!-- adapted from http://www.xsltfunctions.com/xsl/functx_month-name-en.html -->
                <xsl:sequence select="
   ('January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December')
   [fn:month-from-date(current-date())]"/>
	   <!-- <xsl:value-of select="fn:month-from-date(current-date())"/> -->
		<xsl:text> </xsl:text>
		<xsl:value-of select="fn:year-from-date(current-date())"/>
	</xsl:variable>
	
	<xsl:variable name="cellColorAttribute"><xsl:text>#eeffee</xsl:text></xsl:variable>
	<xsl:variable name="cellColorNode"     ><xsl:text>#ffffff</xsl:text></xsl:variable>
	<xsl:variable name="cellColorNodeField"><xsl:text>#f4f4f4</xsl:text></xsl:variable>
	<xsl:variable name="cellColorX3Dv4"    ><xsl:text>#ffffbb</xsl:text></xsl:variable>
	
	<!-- ****** root:  start of file ****************************************************** -->
	<xsl:template match="/">
		<xsl:message>
			<xsl:text>Processing X3D Tooltips</xsl:text>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$version"/>
			<xsl:if test="$tooltipLanguage">
				<xsl:text> in </xsl:text>
				<xsl:value-of select="$tooltipLanguage"/>
			</xsl:if>
			<xsl:text> ...</xsl:text>
		</xsl:message>
<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "https://www.w3.org/TR/html4/loose.dtd">

]]></xsl:text>
		<!-- first pass through entire tooltip file generates the output HTML files. -->
		<xsl:apply-templates/>
		<xsl:message>... X3D Tooltip help-page generation complete.</xsl:message>
		<!-- perform other versions and schema next -->

	</xsl:template>

	<!-- ****** DTDProfile: topmost element****************************************************** -->
	<xsl:template match="DTDProfile">
                 <xsl:variable name="langValue">
                     <xsl:choose>
                            <!-- TODO m17 add here for Chinese-->
                            <xsl:when test="$tooltipLanguage='Chinese'">
                                    <xsl:text>zh</xsl:text>
                            </xsl:when>								
                            <xsl:when test="$tooltipLanguage='French'">
                                    <xsl:text>fr</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage='German'">
                                    <xsl:text>de</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage='Italian'">
                                    <xsl:text>it</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage='Japanese'">
                                    <xsl:text>jp</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage='Korean'">
                                    <xsl:text>kr</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage='Portuguese'">
                                    <xsl:text>pt</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage='Spanish'">
                                    <xsl:text>es</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage='Thai'">
                                    <xsl:text>th</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage='English'">
                                    <xsl:text>en</xsl:text>
                            </xsl:when>
                            <xsl:when test="$tooltipLanguage">
                                    <xsl:value-of select="$tooltipLanguage"/>
                            </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="langCode">
                    <xsl:choose>
                        <xsl:when test="(string-length($langValue) = 0)">
                            <xsl:text>en</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$langValue"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

		<html lang="{$langCode}">
                    
			<head>
				<link rel="shortcut icon" href="icons/X3DtextIcon16.png" title="X3D" />
				<title>
					<xsl:text> X3D Tooltips </xsl:text>
					<xsl:text> </xsl:text>
							<xsl:choose>								
								<xsl:when test="$tooltipLanguage='Chinese'">
				              		<!-- TODO m17 add here for Chinese-->	
									<xsl:text> 中文版 </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='French'">
									<xsl:text> en Fran&#231;ais </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='German'">
									<xsl:text> auf Deutsch </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Italian'">
									<xsl:text> in Italiano </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Japanese'">
									<xsl:text> 日本語版 </xsl:text> <!-- Yeonsoo Yang -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Korean'">
									<xsl:text> 한국어 </xsl:text> <!-- Hyokwang Lee -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Portuguese'">
									<xsl:text> em Portugu&#234;s </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Spanish'">
									<xsl:text> en Español </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Thai'">
									<xsl:text> ภาษาไทย </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage">
									<xsl:text> in </xsl:text>
									<xsl:value-of select="$tooltipLanguage"/>
								</xsl:when>
							</xsl:choose>
					<xsl:text> version </xsl:text>
                    <xsl:value-of select="$version"/>
                    <xsl:if test="($version = '3.3') and (($tooltipLanguage = 'English') or (string-length($tooltipLanguage) = 0))">
                        <xsl:text> (with&#160;X3D&#160;version&#160;4.0&#160;draft)</xsl:text>
                    </xsl:if>
					<!-- &#160; = &nbsp; -->
				</title>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
			</head>
			<!-- #000080 = navy -->
			<!--  marginheight="10" marginwidth="10" topmargin="10" leftmargin="0" -->
			<body bgcolor="#99cccc" link="navy" vlink="#447777" alink="#447777" style="margin: 10px">

                            <a name="top"/>
                            <!-- table white background does not look good on page 
                            <table border="0" cellspacing="0" cellpadding="0" summary="" align="center" bgcolor="#FFFFFF">
                                <tr align="center">
                                    <td><a href="https://www.web3d.org/x3d/what-x3d"><img src="images/x3d2-s.gif" width="154" height="97" border="0" title="to X3D home page" alt="to X3D home page"/></a></td>
                                    <td><pre>   </pre></td>
                                    <td> -->

            <xsl:text>&#10;</xsl:text>

            <!-- outer outline -->
            <table width="92%" border="1" cellspacing="0" cellpadding="0" summary="" align="center" style="background-color:white">
                <tr>
                    <td>

                <table width="100%" border="0" cellspacing="0" cellpadding="0" summary="" align="center" xsl:exclude-result-prefixes="date fn" style="background-color:white">
                    <tr align="center">
                        <td><a href="../content/examples/X3dResources.html" target="_blank"><img src="images/x3d2-s.gif" width="154" height="97" border="0" title="to X3D Resources" alt="to X3D Resources"/></a></td>
                        <td><pre><xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;</xsl:text></pre></td>
                        <td>
                            <h2 align="center">	
                                                        
							<xsl:text>&#10;</xsl:text>
							<xsl:text>Extensible&#160;3D&#160;(X3D) </xsl:text>
                            <xsl:value-of select="$version"/>
							<xsl:text> Tooltips</xsl:text>
							<xsl:choose>
								<!-- TODO m17 add here for Chinese-->
								<xsl:when test="$tooltipLanguage='Chinese'">
									<xsl:text> 中文版 </xsl:text>
								</xsl:when>								
								<xsl:when test="$tooltipLanguage='French'">
									<xsl:text> en&#160;Fran&#231;ais </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='German'">
									<xsl:text> auf Deutsch </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Italian'">
									<xsl:text> in Italiano </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Japanese'">
									<xsl:text> in 日本語版 </xsl:text> <!-- Yeonsoo Yang -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Korean'">
									<xsl:text> 한국어 </xsl:text> <!-- Hyokwang Lee -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Portuguese'">
									<xsl:text> Em&#160;Portugu&#234;s </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Spanish'">
									<xsl:text> en&#160;Español </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Thai'">
									<xsl:text> ภาษาไทย </xsl:text>
								</xsl:when>
								<xsl:when test="$tooltipLanguage='English'">
									<!-- no output -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage">
									<xsl:text> in </xsl:text>
									<xsl:value-of select="$tooltipLanguage"/>
								</xsl:when>
							</xsl:choose>
							<xsl:if test="($version = '3.3') and (($tooltipLanguage = 'English') or (string-length($tooltipLanguage) = 0))"><!--  -->
								<xsl:text> (with&#160;X3D&#160;version&#160;4.0&#160;draft)</xsl:text>
								<!-- &#160; = &nbsp; -->
							</xsl:if>
                            </h2>
                        </td>
                        <td><pre><xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;</xsl:text></pre></td>
                        <td><a href="https://www.web3d.org" target="_blank"><img src="images/web3d_logo2.png" width="120" height="60" border="0" title="to Web3D Consortium home page" alt="to Web3D Consortium home page"/></a></td>
                    </tr>
                </table>
					<xsl:text>&#10;</xsl:text>
                                    <!--
                                    </td>
                                    <td><pre>    </pre></td>
                                    <td><a href="https://www.web3d.org"><img src="images/web3d_logo2.png" width="120" height="60" border="0" title="to Web3D home page" alt="to Web3D home page"/></a></td>
                                </tr>
                            </table>
                            -->

					<!-- introduction paragraphs -->
					<table width="100%" summary="" align="center" border="0" cellspacing="0" cellpadding="6" style="background-color:white">
						<tr>
							<td align='center'>
	
							<!-- translations go here -->
							<xsl:choose>
								<!-- TODO m17 add here for Chinese-->
								<xsl:when test="$tooltipLanguage='Chinese'">
									<xsl:text>此工具提示提供了每个X3D节点(元素)和域(属性)的描述和创作技巧，也为 
									</xsl:text>
										<a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit 创作工具</a>
									<xsl:text> 和 </xsl:text>

                                                                        <!-- TODO
									<xsl:text>提供了上下文敏感的支持，此工具提示也将整合到将来的
									</xsl:text>
										<a href="https://www.web3d.org/specifications" target="_blank">X3D Schema</a>
									<xsl:text> 中。&#10;</xsl:text>
                                                                        -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage='French'">
									<xsl:text>Ces tooltips fournissent des descriptions r&#232;capitulatives pour
									chaque noeud (&#232;l&#232;ment) et chaque zone (attribut) X3D. Ils fournissent un
									support pour le outil de création
									</xsl:text>
                                                                        <a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit</a>
									<xsl:text> et le </xsl:text>

                                                                        <!-- TODO
									<xsl:text>
									et seront int&#232;gr&#232;s dans le prochain
									</xsl:text>
										<a href="https://www.web3d.org/specifications" target="_blank">sch&#232;ma de X3D</a>
									<xsl:text>.</xsl:text>
									<xsl:text>&#10;</xsl:text>
                                                                        -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage='German'">
									<xsl:text>F&#252;r alle X3D-Knoten (Elemente) und deren Felder (Attribute) existieren Tooltips mit kurzen Beschreibungen und
									Hinweisen f&#252;r Szenenautoren. Diese dienen als kontextsensitive Hilfe f&#252;r das
									</xsl:text>
                                                                        <a href="https://savage.nps.edu/X3D-Edit" target="_blank">Autorenwerkzeug X3D-Edit</a>
									<xsl:text> und der </xsl:text>
                                                                        <!-- TODO
									<xsl:text>
									und werden auch im k&#252;nftigen 
									</xsl:text>
										<a href="https://www.web3d.org/specifications" target="_blank">X3D Schema</a>
									<xsl:text> integriert sein.</xsl:text>
									<xsl:text>&#10;</xsl:text>
                                                                        -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Italian'">
									<xsl:text>Questi commenti forniscono delle descrizioni riassuntive e dei consigli
									utili per ogni nodo (elemento) e campo (attributo) di X3D. Essi
									forniscono supporto dipendente dal contesto per lo strumento di sviluppo 
									</xsl:text>
                                                                        <a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit</a>
									<xsl:text> e la </xsl:text>

                                                                        <!-- TODO
									<xsl:text> e saranno integrati nel futuro 
									</xsl:text>
										<a href="https://www.web3d.org/specifications" target="_blank">Schema X3D</a>
									<xsl:text>.&#10;</xsl:text>
                                                                        -->
								</xsl:when>
                                                                
                                                                <!-- Yeonsoo Yang -->
								<xsl:when test="$tooltipLanguage='Japanese'">
									<xsl:text>
										X3Dのツールチップは、X3D 仕様書3.3
									</xsl:text>
                                                                        <xsl:value-of select="$version"/>
									<xsl:text> で記述している各X3Dノード（要素）とフィールド（属性）の概要とオーサリングのヒントを提供します。.
                                                                        </xsl:text>
                                                                        
                                                                        <br />
                                                                        <xsl:text>(These are draft tooltips for </xsl:text>
                                                                        <xsl:value-of select="$tooltipLanguage"/>
                                                                        <xsl:text>.) </xsl:text>
                                                                                
									<xsl:text>
										The X3D tooltips provide context-sensitive support for authors and are usable within tools (such as
									</xsl:text>
									<a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit</a><xsl:text>). </xsl:text>
                                                                        <xsl:text>Each node&apos;s table entry also provides appropriate links to the
                                                                        </xsl:text>
								</xsl:when>
                                                                
                                                                <!-- Hyokwang Lee -->
								<xsl:when test="$tooltipLanguage='Korean'">
									<xsl:text>
										X3D 툴팁(Tooltips)은 버전 
									</xsl:text>
                                                                        <xsl:value-of select="$version"/>
									<xsl:text> 사양(Specification)의 각 X3D 노드(엘리먼트)와 필드(속성)에 대한 
                                                                                간략한 설명과 저작(authoring) 힌트를 제공한다. 
									</xsl:text>
									<a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit</a>
                                                                        <xsl:text>과 같은 툴 및 저자들을 위한 상황 대응적인 지원(context-sensitive support)이 제공되며, 
                                                                                또한 각 노드 별로 
                                                                        </xsl:text>
                                                                        <xsl:element name="a">
                                                                                <xsl:attribute name="href">
                                                                                        <xsl:value-of select="$x3dSpecificationUrlBase"/>
                                                                                        <xsl:text>/</xsl:text>
                                                                                        <xsl:value-of select="$x3dSpecificationTop"/>
                                                                                </xsl:attribute>
                                                                                <xsl:attribute name="target">
                                                                                        <xsl:text>_blank</xsl:text>
                                                                                </xsl:attribute>
                                                                                <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;추상&amp;nbsp;사양</xsl:text>
                                                                        <xsl:text disable-output-escaping="yes"> (X3D&amp;nbsp;Abstract Specification)
                                                                        </xsl:text>
                                                                        </xsl:element><xsl:text>,
                                                                        </xsl:text>
                                                                        <xsl:element name="a">
                                                                            <xsl:attribute name="target">
                                                                                <xsl:text>_blank</xsl:text>
                                                                            </xsl:attribute>
                                                                            <xsl:attribute name="href">
                                                                                <xsl:value-of select="$schemaDocumentationUrl"/>
                                                                            </xsl:attribute>
                                                                            <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;스키마&amp;nbsp;문서</xsl:text>
                                                                        <xsl:text disable-output-escaping="yes"> (X3D&amp;nbsp;Schema Documentation)</xsl:text>
                                                                        </xsl:element><xsl:text>,
									</xsl:text>
                                                                        <xsl:element name="a">
                                                                            <xsl:attribute name="target">
                                                                                <xsl:text>_blank</xsl:text>
                                                                            </xsl:attribute>
                                                                            <!--
                                                                            <xsl:attribute name="title">
                                                                                <xsl:value-of select="@name"/>
                                                                                <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                                                            </xsl:attribute>
                                                                            <xsl:attribute name="alt">
                                                                                <xsl:value-of select="@name"/>
                                                                                <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                                                            </xsl:attribute>
                                                                            -->
                                                                            <xsl:attribute name="href">
                                                                                <xsl:value-of select="$doctypeDocumentationUrl"/>
                                                                            </xsl:attribute>
                                                                            <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;DOCTYPE&amp;nbsp;문서</xsl:text>
                                                                        <xsl:text disable-output-escaping="yes"> (X3D&amp;nbsp;DOCTYPE Documentation)</xsl:text>
                                                                        </xsl:element>                                                                        
                                                                        <xsl:text>에 대한 적절한 링크가 제공된다.
									</xsl:text>                                                                        
								</xsl:when>
                                                                                                                                
								<xsl:when test="$tooltipLanguage='Portuguese'">
									<xsl:text>Estas dicas de ferramentas (tooltips) fornecem uma descri&#231;&#227;o
									resumida e dicas de uso para cada n&#243; X3D (elemento) e campo (atributo).
									Elas fornecem ajuda sens&#237;vel ao contexto para a ferramenta de edi&#231;&#227;o
									</xsl:text>
                                                                        <a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit</a>
									<xsl:text> eo </xsl:text>

                                                                        <!-- TODO
									<xsl:text>
									e ser&#225; integrada com o
									</xsl:text>
										<a href="https://www.web3d.org/specifications" target="_blank">X3D Schema</a>
									<xsl:text>
									que esta para surgir.&#10;</xsl:text>
                                                                        -->
								</xsl:when>
								<xsl:when test="$tooltipLanguage='Spanish'">
									<xsl:text>Estas notas de ayuda proporcionan descripciones resumidas y sugerencias de
									autor&#237;a para cada nodo (elemento) X3D y campo (atributo). Proporcionan
									ayuda contextual en la herramienta de autor 
									</xsl:text>
                                                                        <a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit</a>
									<xsl:text> y el </xsl:text>

                                                                        <!-- TODO
									<xsl:text> y se integrar&#225;n en el pr&#243;ximo 
									</xsl:text>
										<a href="https://www.web3d.org/specifications" target="_blank">X3D Schema</a>
									<xsl:text>.&#10;</xsl:text>
                                                                        -->
								</xsl:when>
                                                                <!-- Hassadee Pimsuwan -->
								<xsl:when test="$tooltipLanguage='Thai'"> 
									<xsl:text>
										X3D tooltips เป็นเอกสารที่รวบรวมคำอธิบายโดยสรุปและข้อเสนอแนะของแต่ละโหนด (element) และฟิลด์ (attribute) ในรุ่น
									</xsl:text>
                                                                        <xsl:value-of select="$version"/>
									<xsl:text>
										เอกสารนี้ยังรวมถึงคำอธิบายช่วยเหลือสำหรับผู้ใช้เครื่องมือ อย่างเช่น 
									</xsl:text>
									<a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit</a><xsl:text> ด้วย</xsl:text>
                                                                        <xsl:text>โดยแต่ละโหนดจะมีการโยงไปถึง
									</xsl:text>

                                                                        <!-- TODO
                                                                        <xsl:text> และกำลังจะรวมเข้ากับ
									</xsl:text>
										<a href="https://www.web3d.org/specifications" target="_blank">X3D Schema</a>
									<xsl:text>.&#10;</xsl:text>
                                                                        -->
								</xsl:when>
 
								<xsl:otherwise> <!-- English -->
                                                                     <xsl:if test="not($tooltipLanguage='English') and not(string-length($tooltipLanguage)=0)">
                                                                                <xsl:text>(These are draft tooltips for</xsl:text>
                                                                                <xsl:value-of select="$tooltipLanguage"/>
                                                                                <xsl:text>.) </xsl:text>
                                                                        </xsl:if>
									<xsl:text>
										X3D Tooltips provide authoring hints for each
                                        node and field found in X3D Architecture Specification 
									</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="($version = '3.3') and (($tooltipLanguage = 'English') or (string-length($tooltipLanguage) = 0))"><!--  -->
                                            <xsl:text>, version </xsl:text>
                                            <xsl:value-of select="$version"/>
                                            <!-- &#160; = &nbsp; -->
                                        </xsl:when>
                                        <xsl:when test="($version = '4.0') and (($tooltipLanguage = 'English') or (string-length($tooltipLanguage) = 0))"><!--  -->
                                            <a href="https://www.web3d.org/x3d4" target="x3dv4">version 4</a>
                                            <xsl:text>&#160;draft</xsl:text>
                                            <!-- &#160; = &nbsp; -->
                                        </xsl:when>
                                    </xsl:choose>
									<xsl:text>.
									</xsl:text>

									<br />
                                    <br />
                                    <xsl:text>
										X3D Tooltips provide context-sensitive support for authors and are usable within tools (such as
									</xsl:text>
									<a href="https://savage.nps.edu/X3D-Edit" target="_blank">X3D-Edit</a><xsl:text>). </xsl:text>
									<xsl:text> Each node&apos;s table entry also provides appropriate links to the
									</xsl:text>

                                                                        <!-- TODO
                                                                        <xsl:text> and will be integrated with the
									</xsl:text>
										<a href="https://www.web3d.org/specifications" target="_blank">X3D Schema</a>
									<xsl:text>.&#10;</xsl:text>
                                                                        -->
								</xsl:otherwise>
							</xsl:choose>
                                                        <!-- common header finish for all languages -->


                                    <!-- this will not be applied to korean edition. Hyokwang Lee -->
                                    <xsl:if test="not($tooltipLanguage='Korean')">

                                        <xsl:element name="a">
                                                <xsl:attribute name="href">
                                                        <xsl:value-of select="$x3dSpecificationUrlBase"/>
                                                        <xsl:text>/</xsl:text>
                                                        <xsl:value-of select="$x3dSpecificationTop"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="target">
                                                        <xsl:text>_blank</xsl:text>
                                                </xsl:attribute>
                                                <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;Abstract&amp;nbsp;Specification</xsl:text>
                                        </xsl:element>
                                        <xsl:text>,</xsl:text>
                                        <xsl:text>&#10;</xsl:text>

                                        <xsl:element name="a">
                                            <xsl:attribute name="target">
                                                <xsl:text>_blank</xsl:text>
                                            </xsl:attribute>
                                            <!--
                                            <xsl:attribute name="title">
                                                <xsl:value-of select="@name"/>
                                                <xsl:text> documentation, X3D Schema</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="alt">
                                                <xsl:value-of select="@name"/>
                                                <xsl:text> documentation, X3D Schema</xsl:text>
                                            </xsl:attribute>
                                            -->
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$schemaDocumentationUrl"/>
                                            </xsl:attribute>
                                            <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;Schema&amp;nbsp;Documentation</xsl:text>
                                        </xsl:element>
                                        <xsl:text>,</xsl:text>
                                        <xsl:text>&#10;</xsl:text>

                                        <xsl:element name="a">
                                            <xsl:attribute name="target">
                                                <xsl:text>_blank</xsl:text>
                                            </xsl:attribute>
                                            <!--
                                            <xsl:attribute name="title">
                                                <xsl:value-of select="@name"/>
                                                <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="alt">
                                                <xsl:value-of select="@name"/>
                                                <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                            </xsl:attribute>
                                            -->
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$doctypeDocumentationUrl"/>
                                            </xsl:attribute>
                                            <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;DOCTYPE&amp;nbsp;Documentation</xsl:text>
                                        </xsl:element>

                                        <xsl:text>,&#10;</xsl:text>
                                        <xsl:text> </xsl:text>
                                        
                                        <xsl:element name="a">
                                            <xsl:attribute name="target">
                                                <xsl:text>_blank</xsl:text>
                                            </xsl:attribute>
                                            <!--
                                            <xsl:attribute name="title">
                                                <xsl:value-of select="@name"/>
                                                <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="alt">
                                                <xsl:value-of select="@name"/>
                                                <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                            </xsl:attribute>
                                            -->
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$jsonDocumentationUrl"/>
                                            </xsl:attribute>
                                            <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;JSON&amp;nbsp;Documentation&amp;nbsp;(draft)</xsl:text>
                                        </xsl:element>
                                        <xsl:text>,&#10;</xsl:text>
                                        <xsl:text> </xsl:text>
                                        <xsl:element name="a">
                                            <xsl:attribute name="target">
                                                <xsl:text>_blank</xsl:text>
                                            </xsl:attribute>
                                            <!--
                                            <xsl:attribute name="title">
                                                <xsl:value-of select="@name"/>
                                                <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="alt">
                                                <xsl:value-of select="@name"/>
                                                <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                            </xsl:attribute>
                                            -->
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$x3dRegexUrl"/>
                                            </xsl:attribute>
                                            <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;Regular&amp;nbsp;Expressions&amp;nbsp;(regexes)</xsl:text>
                                        </xsl:element>
                                        <xsl:text>,&#10;</xsl:text>
                                        <xsl:text>and  </xsl:text>
                                        <xsl:element name="a">
                                            <xsl:attribute name="target">
                                                <xsl:text>_blank</xsl:text>
                                            </xsl:attribute>
                                            <!--
                                            <xsl:attribute name="title">
                                                <xsl:value-of select="@name"/>
                                                <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="alt">
                                                <xsl:value-of select="@name"/>
                                                <xsl:text> documentation, X3D DOCTYPE</xsl:text>
                                            </xsl:attribute>
                                            -->
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$x3djsailUrl"/>
                                            </xsl:attribute>
                                            <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;Java&amp;nbsp;SAI&amp;nbsp;Library&amp;nbsp;(X3DJSAIL)</xsl:text>
                                        </xsl:element>
                                        <xsl:text>.</xsl:text>
                                        <xsl:text>&#10;</xsl:text>
                                    </xsl:if>
                                    <!--
									<xsl:text>
                                        Additional information about X3D nodes can be found in the
									</xsl:text>
                                    <xsl:element name="a">
                                        <xsl:attribute name="target">
                                            <xsl:text>_blank</xsl:text>
                                        </xsl:attribute>
                                        <xsl:attribute name="href">
                                            <xsl:text>https://www.web3d.org/x3d/content/examples/X3dSceneAuthoringHints.html</xsl:text>
                                        </xsl:attribute>
                                        <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;Scene&amp;nbsp;Authoring&amp;nbsp;Hints</xsl:text>
                                    </xsl:element>
                                    <xsl:text>.</xsl:text>
                                    -->
                                </td>
                            </tr>

                            <xsl:if test="not($version='4.0')">
                                <tr>
                                    <td align='center'>
                                        <xsl:text>&#10;</xsl:text>
                                        <xsl:text>Complete support for the latest X3D specification can be found in the </xsl:text>
                                        <!-- relative link for local/online use -->
                                        <a href="X3dTooltips.html">X3D Tooltips version 4.0 (draft)</a>
                                        <xsl:text>.</xsl:text>
                                        <xsl:text>&#10;</xsl:text>
                                    </td>
                                </tr>
                            </xsl:if>
                                            
                        </table>

                    </td>
                </tr>
            </table>
            
                    <xsl:apply-templates/>
			
                </body>
            </html>

        </xsl:template>

	<!-- ****** "elements" element****************************************************** -->
	<xsl:template match="elements">
	
		<!-- table of contents index, which would be better as a sorted column -->

		<blockquote style="text-align: justify; text-align: full" >
			<xsl:for-each select="element[not(starts-with(@name,'XML_')) and not(@name='USE')]">
				<xsl:sort select="@name" order="ascending" case-order="lower-first"/>
                <xsl:text>&#10;</xsl:text>
				<font size="-1">
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>#</xsl:text>
							<xsl:value-of select="@name"/>
						</xsl:attribute>
						<xsl:value-of select="@name"/>
					</xsl:element>
				</font>
                <xsl:if test="not(position() = last())">
                    <xsl:text>&#160;&#160;</xsl:text>
                    <!-- &#160; = &nbsp; -->
                </xsl:if>
			</xsl:for-each>
            <xsl:text>&#10;</xsl:text>
		</blockquote>
		<xsl:text>&#10;&#10;</xsl:text>

		<!-- special sections index -->
		<blockquote style="text-align: justify; text-align: center" >
            <xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#accessType"><i>accessType</i> Definitions</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#type"><i>type</i> Definitions</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#XML">XML data types</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#RangeIntervals">Range Intervals</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#FieldTypesTable">Field Type Definitions</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#credits">Credits and Translations</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="../content/examples/X3dResources.html">X3D Resources</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="../content/examples/X3dSceneAuthoringHints.html">X3D Scene Authoring Hints</a></font>
        </blockquote> 	
		<xsl:text>&#10;&#10;</xsl:text>

		<!-- node types index -->
		<blockquote style="text-align: justify; text-align: full" >
            <xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFBool">SFBool</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFBool">MFBool</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFColor">SFColor</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFColor">MFColor</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFColorRGBA">SFColorRGBA</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFColorRGBA">MFColorRGBA</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFInt32">SFInt32</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFInt32">MFInt32</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFFloat">SFFloat</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFFloat">MFFloat</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFDouble">SFDouble</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFDouble">MFDouble</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFImage">SFImage</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFImage">MFImage</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFNode">SFNode</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFNode">MFNode</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFRotation">SFRotation</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFRotation">MFRotation</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFString">SFString</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFString">MFString</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFTime">SFTime</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFTime">MFTime</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFVec2f">SFVec2f</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFVec2f">MFVec2f</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFVec2d">SFVec2d</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFVec2d">MFVec2d</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFVec3f">SFVec3f</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFVec3f">MFVec3f</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFVec3d">SFVec3d</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFVec3d">MFVec3d</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFVec4f">SFVec4f</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFVec4f">MFVec4f</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFVec4d">SFVec4d</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFVec4d">MFVec4d</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFMatrix3f">SFMatrix3f</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFMatrix3f">MFMatrix3f</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFMatrix3d">SFMatrix3d</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFMatrix3d">MFMatrix3d</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFMatrix4f">SFMatrix4f</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFMatrix4f">MFMatrix4f</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#SFMatrix4d">SFMatrix4d</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
            <font size="-1"><a href="#MFMatrix4d">MFMatrix4d</a></font><xsl:text>&#160;&#160;</xsl:text><xsl:text>&#10;</xsl:text>
        </blockquote> 	
		<xsl:text>&#10;&#10;</xsl:text>


		<!-- Detailed table containing names and tooltips for elements, attributes -->
		
		<blockquote>
		<!-- width="900" -->
		<table summary="" align="center" width="98%" border="1" cellspacing="0" cellpadding="1">

			<xsl:apply-templates select="element[not(starts-with(@name,'XML_'))]">
			   <xsl:sort select="@name" order="ascending" case-order="lower-first"/>
			</xsl:apply-templates>
                        
		<!-- bookmark links row-->
		<tr align="left" valign="bottom">
                    <td bgcolor="#669999" align="right">
                            <!-- bookmark -->
                            <xsl:element name="a">
                                    <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                                    <font size="-1">
                                            <xsl:text>&#160;</xsl:text>
                                            <!-- &#160; = &nbsp; -->
                                    </font>
                            </xsl:element>
                    </td>
                    <!--m17 add here "width="600"" for word wrap 	width="600"-->
                    <td bgcolor="#669999" align="right" colspan="3">
                        <font size="-1" color="black">
                            <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>#accessType</xsl:text></xsl:attribute>
                                <xsl:text>accessType</xsl:text>
                            </xsl:element>
                            <xsl:text> and </xsl:text>
                            <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>#type</xsl:text></xsl:attribute>
                                <xsl:text>type</xsl:text>
                            </xsl:element>
                        </font>
                        <xsl:text>&#160;&#160;&#160;</xsl:text>
                        <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>#credits</xsl:text></xsl:attribute>
                                <font size="-1" color="black">
                                        <xsl:text>Credits and Translations</xsl:text>
                                        <!-- &#160; = &nbsp; -->
                                </font>
                        </xsl:element>
                        <xsl:text>&#160;&#160;&#160;</xsl:text>
                        <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>../content/examples/X3dResources.html</xsl:text></xsl:attribute>
                                <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
                                <font size="-1" color="black">
                                        <xsl:text>X3D Resources</xsl:text>
                                        <!-- &#160; = &nbsp; -->
                                </font>
                        </xsl:element>
                        <xsl:text>&#160;&#160;&#160;</xsl:text>
                        <!--
                        <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>#top</xsl:text></xsl:attribute>
                                <font size="-1" color="black">
                                        <xsl:text>to top</xsl:text>
                                </font>
                        </xsl:element>
                        <xsl:text>&#160;&#160;&#160;</xsl:text>
                        -->
                        <a href="#"><!-- top -->
                           <img src="icons/X3DtextIcon16.png" width="16" height="16" border="0" title="to top" alt="to top" align="right" style="vertical-align:bottom"/>
                        </a>
                    </td>
		</tr>

		</table>
		<xsl:text>&#10;&#10;</xsl:text>
                
		<!-- Summary information table  -->
						
		<table summary="" width="95%" align="center" border="0" cellspacing="0" cellpadding="1">

			<tr>
                            <td colspan="3">

                                <h3>
                                    <!-- Unicode Character 'BOOKMARK' (U+1F516) -->
                                    <a href="#accessType" title="accessType Definitions bookmark">&#128278;</a>&#160;
                                    <a href="#accessType" name="accessType"><i>accessType</i> Definitions</a>
                                    <a href="#"><!-- top -->
                                       <img src="icons/X3DtextIcon16.png" width="16" height="16" border="0" title="to top" alt="to top" align="right" style="vertical-align:bottom"/>
                                    </a>
                                </h3>

                                <p>
									References:
									X3D Abstract Specification 
									<a href="{$x3dSpecificationUrlBase}/Part01/concepts.html#FieldSemantics" target="_blank">4.4.2.2 Field semantics</a>
									and
									X3D XML Encoding
									<a href="https://www.web3d.org/documents/specifications/19776-1/V3.2/Part01/concepts.html#PrototypeAndFieldDeclarationSyntax" target="_blank">4.3.7 Prototype and field declaration syntax</a>
                                </p>

                                <p>
                                    <i>accessType</i> determines whether a field corresponds to event input, event output, or persistent state information.
                                    Events are strictly typed values with a corresponding timestamp.
                                    ROUTE connections must match <i>accessType</i> between source field and target field.
                                </p>
                                <ul>
                                    <li>
                                        <i>initializeOnly</i>:
                                        can be initialized, but cannot send or receive events.
                                        This is usually the case for fields that are considered too computationally expensive to change at run time.
                                    </li>
                                    <li>
                                        <i>inputOutput</i>:
                                        can be initialized, and can also send or receive events during run-time operations.
                                    </li>
                                    <li>
                                        <i>inputOnly</i>:
                                        cannot be initialized or included in a scene file, but can receive input event values via a ROUTE during run-time operations.
                                    </li>
                                    <li>
                                        <i>outputOnly</i>:
                                        cannot be initialized or included in a scene file, but can send output event values via a ROUTE during run-time operations.
                                    </li>
                                </ul>
                                <p>
                                    X3D <i>accessType</i> design keeps 3D graphics rendering fast and interactive,
                                    also helping to keep X3D players small and lightweight.
                                </p>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="3">

                                <h3>
                                    <a name="type"/>
                                    <!-- Unicode Character 'BOOKMARK' (U+1F516) -->
                                    <a href="#type" title="type Definitions bookmark">&#128278;</a>&#160;
                                    <a href="#type" title="type Definitions bookmark"><i>type</i> Definitions</a>
                                    <a href="#"><!-- top -->
                                       <img src="icons/X3DtextIcon16.png" width="16" height="16" border="0" title="to top" alt="to top" align="right" style="vertical-align:bottom"/>
                                    </a>
                                </h3>

                                <p>
                                    The X3D Architecture specification of 
                                    <a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html" target="_blank">field types</a>
                                    classify the possible values for a field.
                                    Each field in each node (i.e. each XML attribute) has a strictly defined data type.
                                    Multiple data types are provided for boolean, integer, floating-point and string values.
                                    X3D is a strongly typed language, meaning that all data must strictly conform to these
                                    <a href="https://en.wikipedia.org/wiki/Data_types" target="_blank">data types</a>
                                    in order for a scene to be correct.
                                </p>
                                
                                <ul>
                                
                                    <li>
                                        Each of the base types are either single-value (SF Single Field) or multiple-value (MF Multiple Field).
                                        Examples:  SFFloat (single-value), SFVec2f (singleton 2-tuple), SFVec3f (singleton 3-tuple), SFOrientation (singleton 4-tuple for axis-angle values).
                                    </li>

                                    <li>
                                        Arrays are also provided for all base types.  Nomenclature:
                                        <b>SF = Single Field</b> (single  value of base type), <b>MF = Multiple Field</b> (array of base-type values).
                                        Examples:  MFFloat (array of zero or more SFFloat values), MFVec4d (array of zero or more 4-tuple SFVec4d values), etc.
                                    </li>

                                    <li>
                                        The X3D Schema is able to validate numeric type information and array tuple sizes in X3D scenes
                                        for field initializations (having <i>accessType</i> of <i>initializeOnly</i> and <i>inputOutput</i>)
                                        that appear within an X3D file.
                                    </li>
 
                                    <li>
                                        ROUTEs pass events, which are strictly typed values with a corresponding timestamp.
                                        ROUTE connections must match type between source field and target field.
                                        Since they are transient, event values themselves cannot appear within an X3D file.
                                    </li>

                                    <li>
                                        <!-- TODO check scene authoring hints -->
                                        For MF Multiple-Field arrays, commas between values are normally treated as whitespace.
                                        However, X3D Schema validation will not accept commas that appear within vector values, only between values.
                                        MFColor examples: color="0.25 0.5 0.75, 1 1 0" is valid while color="0.25, 0.5, 0.75, 1, 1, 0" is invalid.
                                        This is an authoring assist to help authors troubleshoot errors in long arrays of values.
                                    </li>

                                    <li>
                                        Failure to match data types correctly is an error!
                                        Types must match during scene validation, scene loading, and at run time.
                                        This is A Good Thing since it allows authors to find problems when they exist,
                                        rather than simply hoping (perhaps mistakenly) that everything will work for end users.
                                    </li>
                                    
                                </ul>
                                <p>
                                    <a name="XML"></a><a name="DataTypes"></a><a name="XmlDataTypes"></a>
                                    <!-- Unicode Character 'BOOKMARK' (U+1F516) -->
                                    <a href="#XML" title="XML Data Types bookmark">&#128278;</a>&#160;
                                    <a href="#XML" title="XML Data Types bookmark">XML Data Types</a>
                                    and default attribute values defined in the
                                    <a href="https://www.w3.org/TR/REC-xml" target="_blank">Extensible Markup Language (XML) Recommendation</a>
                                    are also included in these tooltips.
                                </p>
                                <ul>
                                    <li>
                                        <a name="CDATA"><b><a href="https://www.w3.org/TR/REC-xml/#syntax" target="_blank">CDATA</a></b></a>
                                        is an XML term for
                                        <a href="https://www.w3.org/TR/REC-xml/#syntax" target="_blank">Character Data</a>.  
                                        The base type for all XML attributes
                                        consists of string-based CDATA characters.  
                                        CDATA is used throughout the X3D DOCTYPE definitions, which can only check
                                        for the presence of legal strings and thus are not able to validate numeric type information.
                                        XML Schema provides stricter validation based on data types.
                                    </li>

                                    <li>
                                        <a name="XMLCOMMENT"><b><a href="https://www.w3.org/TR/REC-xml/#sec-comments" target="_blank">COMMENT</a></b></a>
                                        statements contain string characters.
                                        Comments have great value for documenting design and significance in X3D model source. 
                                        Comment strings cannot contain a double hyphen <code>--</code> since that character pair is part of the comment terminator.
                                        XML comments can only appear between other elements and comments, and are not allowed within element or attribute markup.
                                        Comments have no effect on X3D model rendering and are not accessible programmatically at run time.  Example:
                                        <br />
                                        <code>&lt;-- here is my most excellent XML comment! --&gt;</code>
                                    </li>

                                    <li>
                                        <!-- &#160; = &nbsp; -->
                                        <a name="DTD"></a><a name="DOCTYPE"><b><a href="https://www.w3.org/TR/REC-xml/#sec-prolog-dtd" target="_blank">DOCTYPE</a></b></a>
                                        statements are Document Type Declaration&#160;(DTD) statements, immediately following the initial XML prolog statement in an .x3d file.
                                        DOCTYPE statements enable XML-aware document processors to validate parent-child node relationships and element-attribute string values.  
                                        DOCTYPE validation is always optional.
                                        Allowed DOCTYPE statements for each X3D version are found at
                                        <a href="https://www.web3d.org/specifications" target="_blank">X3D Specifications: Schema and DOCTYPE Validation</a>.
                                    </li>

                                    <li>
                                        <a name="ENUMERATION"><b><a href="https://www.w3.org/TR/REC-xml/#enum" target="_blank">ENUMERATION</a></b></a>
                                        indicates that the given value can only equal one of several allowed 
                                        <a href="#NMTOKEN">NMTOKEN</a> values.
                                    </li>

                                    <li>
                                        <a name="FIXED"><b><a href="https://www.w3.org/TR/REC-xml/#FixedAttr" target="_blank">FIXED</a></b></a>
                                        indicates that the given value is required and no other value is allowed.
                                        A FIXED value of empty string &quot;&quot; indicates that
                                        no value is allowed to appear in this attribute.
                                    </li>

                                    <li>
                                        <a name="ID"><b><a href="https://www.w3.org/TR/REC-xml/#sec-attribute-types" target="_blank">ID</a></b></a>
                                        is a NMTOKEN that is unique within the scene, corresponding to the DEF attribute in X3D.
                                    </li>

                                    <li>
                                        <a name="IDREF"><b><a href="https://www.w3.org/TR/REC-xml/#sec-attribute-types" target="_blank">IDREF</a></b></a>
                                        is a NMTOKEN reference to one of these unique scene IDs, corresponding to the USE attribute in X3D.
                                    </li>

                                    <li>
                                        <a name="IMPLIED"><b><a href="https://www.w3.org/TR/REC-xml/#sec-attr-defaults" target="_blank">IMPLIED</a></b></a> 
                                        means that that no default value is provided for this attribute.
                                    </li>

                                    <li>
                                        <a name="NMTOKEN"><b><a href="https://www.w3.org/TR/REC-xml/#sec-common-syn" target="_blank">NMTOKEN</a></b></a>
                                        is an XML term for 
                                        <a href="https://www.w3.org/TR/REC-xml/#sec-common-syn">Name Token</a>.  
                                        NMTOKEN is a special kind of
                                        <a href="#CDATA">CDATA</a>
                                        string that must match naming requirements for legal characters, with no whitespace characters allowed.
                                        Additionally, from XML specification: disallowed initial characters for Names include numeric digits, diacritics (letter with accent or marking), 
                                        the "." period character (sometimes called full stop) and the "-" hyphen character.
										For further information see
										<a href="https://www.web3d.org/x3d/content/examples/X3dSceneAuthoringHints.html#NamingConventions">X3D Scene Authoring Hints: Naming Conventions</a>.
										<!-- TODO link regex -->
                                    </li>

                                    <li>
                                        <a name="NMTOKENS"><b><a href="https://www.w3.org/TR/REC-xml/#sec-common-syn" target="_blank">NMTOKENS</a></b></a>
                                        is an XML term for an array of 
                                        <a href="#NMTOKEN">NMTOKEN</a> values.
                                    </li>

                                    <li>
                                        <a name="xs:token"><b><a href="https://www.w3.org/TR/xmlschema11-2/#token" target="_blank">xs:token</a></b></a>
                                        is similar to NMTOKEN string and allows further restrictions via regular expression (regex) pattern.
                                        No leading, trailing or multiple-adjacent whitespace characters can occur.
                                    </li>

                                    <li>
                                        <a name="REQUIRED"><b><a href="https://www.w3.org/TR/REC-xml/#sec-attr-defaults" target="_blank">REQUIRED</a></b></a>
                                        means that an attribute value MUST always be provided.
                                    </li>
                                </ul>
                                
                                <p>
									<!-- Unicode Character 'BOOKMARK' (U+1F516) -->
                                    <a href="#RangeIntervals" title="RangeIntervals bookmark">&#128278;</a>&#160;<a name="RangeIntervals"><a href="#RangeIntervals"><b>Range Intervals</b></a></a> <!-- self-linking -->
                                    may be defined to indicate lower and upper bounds on allowed attribute values.
                                    These are typically defined by the X3D Architecture Specification in order to avoid illegal or illogical results.
                                    Value constraints being within allowed range intervals are checked by schema validation tools (but not XML DTD).
                                    Example range intervals:
                                </p>
                                <ul>
                                    <li>
                                        <b><code>[0,1]</code></b> &#160; &#160; places limits on an allowed value from range 0 to 1, inclusive.
                                    </li>
                                    <li>
                                        <b><code>(0,+&#8734;)</code></b> &#160; is positive, i.e. greater than zero and less than positive infinity.
                                    </li>
                                    <li>
                                        <b><code>[0,+&#8734;)</code></b> &#160; is non-negative, i.e. greater than or equal to zero, and less than positive infinity.
                                    </li>
                                    <li>
                                        <b><code>[-1,+&#8734;)</code></b> is greater than or equal to -1.
                                    </li>
                                    <li>
                                        <b><code>(-&#8734;,+&#8734;)</code></b> is unbounded, any numeric value is allowed.
                                    </li>
                                </ul>
                                
                                <p>
                                    <a href="#FieldTypesTable" title="Field Types Table bookmark">&#128278;</a>
                                    <a name="FieldTypesTable"></a>
                                    <xsl:text>&#160;</xsl:text>
                                    <!-- &#160; = &nbsp; -->
                                    <a href="#FieldTypesTable">Field Types Table</a>
                                    that follows provides a complete list of X3D data type names, descriptions and example values.
                                    The
                                    <a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html" target="_blank">X3D Architecture Specification: 5 Field type reference</a>
                                    defines default values for each field type.
                                    <a href="#"><!-- top -->
                                       <img src="icons/X3DtextIcon16.png" width="16" height="16" border="0" title="to top" alt="to top" align="right" style="vertical-align:bottom"/>
                                    </a>
                                </p>
                                
                                <table border="1" cellpadding="2" align="center">
                                    <tr>
                                        <th>
                                            Field-type names
                                        </th>
                                        <th>
                                            Description
                                        </th>
                                        <th width="50%">
                                            Example values
                                        </th>
                                        <th>
                                            <span title="SAI revisions in progress" style="font-size:70%">Scene Access<br/>Interface (SAI)</span>
                                        </th>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left"> 
											<!-- Unicode Character 'BOOKMARK' (U+1F516) -->
											<a href="#SFBool" title="SFBool bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFBoolAndMFBool" target="_blank">SFBool</a>
                                        </td>
                                        <td>
                                            Single-Field boolean value 
                                        </td>
                                        <td>
                                            <a name="SFBool"/>
                                            Default value <b>false</b>.  Example values:
                                            <b>true</b> or <b>false</b> for XML syntax in .x3d files. 
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> capitalization of each boolean XML attribute value must be all lower case, matching HTML.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> XML, Java, JavaScript and JSON syntax is <code>true</code> or <code>false</code>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> ClassicVRML syntax is <code>TRUE</code> or <code>FALSE</code> in .wrl or .x3dv files.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> Python syntax is <code>True</code> or <code>False</code> in .py files.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/Boolean_data_type" target="_blank">Wikipedia: Boolean data type</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFBool.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFBool" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFBool" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFBool.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFBool" title="MFBool bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFBoolAndMFBool" target="_blank">MFBool</a>
                                        </td>
                                        <td>
                                            Multiple-Field boolean array, containing an ordered list of SFBool values
                                        </td>
                                        <td>
                                            <a name="MFBool"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            <b>true false false true</b> for XML syntax in .x3d files.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> capitalization of each boolean XML attribute value must be all lower case, matching HTML.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> XML, Java, JavaScript and JSON syntax is <code>true</code> or <code>false</code>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> ClassicVRML syntax is <code>[ TRUE FALSE FALSE TRUE ]</code> in .wrl or .x3dv files.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> Python syntax is <code>True</code> or <code>False</code> in .py files.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/Boolean_data_type" target="_blank">Wikipedia: Boolean data type</a>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFBool values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFBool.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFBool" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFBool" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFBool.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left">
                                            <a href="#SFColor" title="SFColor bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFColorAndMFColor" target="_blank">SFColor</a>
                                        </td>
                                        <td>
                                            Single-Field color value, red-green-blue, all values in range [0,1]
                                        </td>
                                        <td>
                                            <a name="SFColor"/>
                                            Default value <b>0 0 0</b>.  Example values:
                                            0 0.5 1.0
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://www.web3d.org/x3d/content/examples/X3dSceneAuthoringHints.html#Color" target="_blank">X3D Scene Authoring Hints: Color</a>.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within attribute values are not allowed, and do not pass strict validation.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFColor.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFColor" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFColor" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFColor.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFColor" title="MFColor bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFColorAndMFColor" target="_blank">MFColor</a>
                                        </td>
                                        <td>
                                             Multiple-Field color array, containing an ordered list of SFColor values
                                        </td>
                                        <td>
                                            <a name="MFColor"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            1 0 0, 0 1 0, 0 0 1
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://www.web3d.org/x3d/content/examples/X3dSceneAuthoringHints.html#Color" target="_blank">X3D Scene Authoring Hints: Color</a>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> optional comma characters between singleton 3-tuple SFColor attribute values can help authors keep track of long array definitions.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within contained singleton 3-tuple SFColor values do not pass strict validation.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFColor values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFColor.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFColor" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFColor" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFColor.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left">
                                            <a href="#SFColorRGBA" title="SFColorRGBA bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFColorRGBAAndMFColorRGBA" target="_blank">SFColorRGBA</a>
                                        </td>
                                        <td>
                                            Single-Field color value, red-green-blue alpha (opacity), all values in range [0,1]
                                        </td>
                                        <td>
                                            <a name="SFColorRGBA"/>
                                            Default value <b>0 0 0 0</b>.  Example values:
                                            0 0.5 1.0 0.75
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://www.web3d.org/x3d/content/examples/X3dSceneAuthoringHints.html#Color" target="_blank">X3D Scene Authoring Hints: Color</a>.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within attribute values are not allowed, and do not pass strict validation.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFColorRGBA.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFColorRGBA" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFColorRGBA" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFColorRGBA.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFColorRGBA" title="MFColorRGBA bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFColorRGBAAndMFColorRGBA" target="_blank">MFColorRGBA</a>
                                        </td>
                                        <td>
                                            Multiple-Field color array, containing an ordered list of SFColorRGBA values
                                        </td>
                                        <td>
                                            <a name="MFColorRGBA"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            1 0 0 0.25, 0 1 0 0.5, 0 0 1 0.75
                                            (red green blue, with varying opacity)
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://www.web3d.org/x3d/content/examples/X3dSceneAuthoringHints.html#Color" target="_blank">X3D Scene Authoring Hints: Color</a>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> optional comma characters between singleton 4-tuple SFColorRGBA attribute values can help authors keep track of long array definitions.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within contained singleton 4-tuple SFColorRGBA values do not pass strict validation.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFColorRGBA values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFColorRGBA.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFColorRGBA" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFColorRGBA" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFColorRGBA.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left">
                                            <a href="#SFInt32" title="SFInt32 bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFInt32AndMFInt32" target="_blank">SFInt32</a>
                                        </td>
                                        <td>
                                            Single-Field 32-bit integer value, range <code>[−2,147,483,648&#160;to&#160;2,147,483,647]</code>
                                        </td>
                                        <td>
                                            <a name="SFInt32"/>
                                            Default value <b>0</b>.  Example values: -1 0 7
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/Integer_(computer_science)" target="_blank">Wikipedia: Integer (computer science)</a>.
                                            <br />
                                            <b><font color="#447777">Warning:</font></b> avoid scientific notation or else value is considered floating point.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFInt32.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFInt32" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFInt32" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFInt32.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFInt32" title="MFInt32 bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFInt32AndMFInt32" target="_blank">MFInt32</a>
                                        </td>
                                        <td>
                                            Multiple-Field 32-bit integer array, containing an ordered list of SFInt32 values
                                        </td>
                                        <td>
                                            <a name="MFInt32"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            1 2 3 4 5
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/Integer_(computer_science)" target="_blank">Wikipedia: Integer (computer science)</a>.
                                            <br />
                                            <b><font color="#447777">Warning:</font></b> avoid scientific notation or else value is considered floating point.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFInt32 values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFInt32.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFInt32" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFInt32" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFInt32.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left">
                                            <a href="#SFFloat" title="SFFloat bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFFloatAndMFFloat" target="_blank">SFFloat</a>
                                        </td>
                                        <td>
                                            Single-Field single-precision (32-bit) floating-point value, 9&#160;significant digits, maximum value <code>~3.4&#160;×&#160;10^38</code>
                                        </td>
                                        <td>
                                            <a name="SFFloat"/>
                                            Default value <b>0.0</b>.  Example values:
                                            1.0
                                            0 1 -0.0 5E-6 78.0E+9 1.57
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> do not use illegal values <i>INF</i> (infinity) or <i>NaN</i>&#160;(Not&#160;a&#160;Number).
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/Single-precision_floating-point_format" target="_blank">Wikipedia: Single-precision floating-point format</a>.
                                            and
                                            <a href="https://en.wikipedia.org/wiki/Meter" target="_blank">Meter</a> (British spelling "metre").
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFFloat.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFFloat" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFFloat" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFFloat.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFFloat" title="MFFloat bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFFloatAndMFFloat" target="_blank">MFFloat</a>
                                        </td>
                                        <td>
                                            Multiple-Field single-precision (32-bit)  floating-point array, containing an ordered list of SFFloat values
                                        </td>
                                        <td>
                                            <a name="MFFloat"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            −1 2.0 3.141592653
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/Single-precision_floating-point_format" target="_blank">Wikipedia: Single-precision floating-point format</a>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFFloat values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFFloat.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFFloat" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFFloat" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFFloat.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left">
                                            <a href="#SFDouble" title="SFDouble bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFDoubleAndMFDouble" target="_blank">SFDouble</a>
                                        </td>
                                        <td>
                                            Single-Field double-precision (64-bit) floating-point value, 15-17&#160;significant digits, maximum value <code>~1.8&#160;×&#160;10^308</code>
                                        </td>
                                        <td>
                                            <a name="SFDouble"/>
                                            Default value <b>0.0</b>.  Example values:
                                            2.7128 3.141592653
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/Double-precision_floating-point_format" target="_blank">Wikipedia: Double-precision floating-point format</a>.
                                            and
                                            <a href="https://en.wikipedia.org/wiki/Meter" target="_blank">Meter</a> (British spelling "metre").
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFDouble.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFDouble" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFDouble" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFDouble.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFDouble" title="MFDouble bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFDoubleAndMFDouble" target="_blank">MFDouble</a>
                                        </td>
                                        <td>
                                            Multiple-Field double-precision array, containing an ordered list of SFDouble values
                                        </td>
                                        <td>
                                            <a name="MFDouble"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            −1 2.0 3.14159
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/Double-precision_floating-point_format" target="_blank">Wikipedia: Double-precision floating-point format</a>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFDouble values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFDouble.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFDouble" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFDouble" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFDouble.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left">
                                            <a href="#SFImage" title="SFImage bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFImageAndMFImage" target="_blank">SFImage</a>
                                        </td>
                                        <td>
                                            Single-Field image value.
                                            SFImage fields contain three nonnegative integers representing width, height and number of components [0-4] for the following pixel values, 
                                            followed by width×height hexadecimal (or integer) values representing all of the pixel colors defining the SFIimage texture.
                                        </td>
                                        <td>
                                            <a name="SFImage"/>
                                            Default value <b>0 0 0</b>.
                                            Contains special pixel-encoding parameters and values to numerically create a texture image.
                                            <br />
                                            The tooltip for
                                            <a href="#PixelTexture.image">PixelTexture image field</a> shows example SFImage values.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFImageAndMFImage" target="_blank">X3D Architecture Specification: 5.3.6 SFImage MFImage</a>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://www.web3d.org/x3d/content/examples/X3dSceneAuthoringHints.html#Images" target="_blank">X3D Scene Authoring Hints: Images</a>.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within attribute values are not allowed, and do not pass strict validation.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFImage.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFImage" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFImage" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFImage.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFImage" title="MFImage bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFImageAndMFImage" target="_blank">MFImage</a>
                                        </td>
                                        <td>
                                             Multiple-Field image value, containing an ordered list of SFImage values
                                        </td>
                                        <td>
                                            <a name="MFImage"/>
                                            Default value <b>[&#160;]</b> empty list.
                                            Contains special pixel-encoding parameters and values to numerically create an array of texture images.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFImageAndMFImage" target="_blank">X3D Architecture Specification: 5.3.6 SFImage MFImage</a>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://www.web3d.org/x3d/content/examples/X3dSceneAuthoringHints.html#Images" target="_blank">X3D Scene Authoring Hints: Images</a>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFImage values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFImage.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFImage" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFImage" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFImage.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left">
                                            <a href="#SFNode" title="SFNode bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFNodeAndMFNode" target="_blank">SFNode</a>
                                        </td>
                                        <td>
                                            <a name="SFNode"/>
                                            SFNode Single-Field singleton node. Default value is NULL node, meaning no entry.
                                        </td>
                                        <td>
                                            &lt;Shape/&gt; or Shape
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> o not include keyword NULL for an empty node in XML encoding..
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFNode.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFNode" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFNode" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFNode.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFNode" title="MFNode bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFNodeAndMFNode" target="_blank">MFNode</a>
                                        </td>
                                        <td>
                                            <a name="MFNode"/>
                                             Multiple-Field node array, containing an ordered list of SFNode values.  Default value is an empty list.
                                        </td>
                                        <td>
                                            &lt;Shape/&gt; &lt;Group/&gt; &lt;Transform/&gt;
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> do not include keyword NULL for an empty node list in XML encoding.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFNode.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFNode" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFNode" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFNode.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left">
                                            <a href="#SFRotation" title="SFRotation bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFRotationAndMFRotation" target="_blank">SFRotation</a>
                                        </td>
                                        <td>
                                             Single-Field rotation value using 3-tuple axis, radian angle form
                                        </td>
                                        <td>
                                            <a name="SFRotation"/>
                                            Default value <b>0 0 1 0</b>.  
                                            Model authors and authoring tools may prefer the equivalent zero-rotation default value <b>0 1 0 0</b> since rotation about the vertical Y-axis is most common.
                                            Example values:
                                            0 1 0 1.57
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> initial 3-tuple axis vector cannot hold a zero-magnitude vector.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within attribute values are not allowed, and do not pass strict validation.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/Radian" target="_blank">Wikipedia: Radian</a>,
                                            <a href="https://en.wikipedia.org/wiki/Rotation_matrix" target="_blank">Rotation matrix</a>
                                            and
                                            <a href="https://en.wikipedia.org/wiki/Rotation_formalisms_in_three_dimensions" target="_blank">Rotation formalisms in three dimensions</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFRotation.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFRotation" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFRotation" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFRotation.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFRotation" title="MFRotation bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFRotationAndMFRotation" target="_blank">MFRotation</a>
                                        </td>
                                        <td>
                                             Multiple-Field rotation array, containing an ordered list of SFRotation values
                                        </td>
                                        <td>
                                            <a name="MFRotation"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            0 1 0 0, 0 1 0 1.5707963265, 0 1 0 3.141592653
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> initial 3-tuple axis vectors cannot hold a zero-magnitude vector within contained 4-tuple SFRotation attribute values.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> optional comma characters between singleton 4-tuple SFRotation attribute values can help authors keep track of long array definitions.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within contained singleton 4-tuple SFRotation values do not pass strict validation.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFRotation values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/Radian" target="_blank">Wikipedia: Radian</a>,
                                            <a href="https://en.wikipedia.org/wiki/Rotation_matrix" target="_blank">Rotation matrix</a>
                                            and
                                            <a href="https://en.wikipedia.org/wiki/Rotation_formalisms_in_three_dimensions" target="_blank">Rotation formalisms in three dimensions</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFRotation.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFRotation" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFRotation" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFRotation.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left">
                                            <a href="#SFString" title="SFString bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFStringAndMFString" target="_blank">SFString</a>
                                        </td>
                                        <td>
                                            Single-Field string value
                                        </td>
                                        <td>
                                            <a name="SFString"/>
                                            Default value is empty string <b>""</b>.
                                            <b><font color="#447777">Example:</font></b> "an SFString is a simple string value."
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> do not wrap quotation marks around SFString values.
                                            <br />
                                            <b>
                                                <font color="#ee5500">Warning:</font>
                                                </b> SFString is not defined in ECMAScript Scene Access Interface (SAI),
                                                use string type instead.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> insert backslash characters prior to \&quot;embedded quotation marks\&quot; within an SFString value.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> XML rules for encoding special characters can be found at
                                            <br />
                                            <a href="https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references" target="_blank">Wikipedia: List of XML and HTML character entity references</a>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/String_(computer_science)" target="_blank">Wikipedia: String (computer science)</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFString.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFString" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFString" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFString.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFString" title="MFString bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFStringAndMFString" target="_blank">MFString</a>
                                        </td>
                                        <td>
                                            Multiple-Field string array, containing an ordered list of SFString values (each of which must be quoted).
                                        </td>
                                        <td>
                                            <a name="MFString"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            <b><font color="#447777">Example:</font></b> &quot;EXAMINE&quot; &quot;FLY&quot; &quot;WALK&quot; &quot;ANY&quot;
                                            <br />
                                            <b>
                                                <font color="#ee5500">Warning:</font>
                                                </b> MFString is not defined in ECMAScript Scene Access Interface (SAI),
                                                use string[] array type instead.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> XML rules for encoding special characters can be found at
                                            <br />
                                            <a href="https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references" target="_blank">Wikipedia: List of XML and HTML character entity references</a>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/String_(computer_science)" target="_blank">Wikipedia: String (computer science)</a>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFString values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFString.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFString" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFString" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFString.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left">
                                            <a href="#SFTime" title="SFTime bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFTimeAndMFTime" target="_blank">SFTime</a>
                                        </td>
                                        <td>
                                            Single-Field time value in seconds, specified as a double-precision (64-bit) floating point number, 15-17&#160;significant digits, maximum value <code>~1.8&#160;×&#160;10^308</code>
                                        </td>
                                        <td>
                                            <a name="SFTime"/>
                                            Default value <b>-1</b>.  Example values:
                                            0, 10 (seconds), or -1 (indicating no actual time value has been provided).
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> Time values are usually either a system time (matching current clock time) in seconds, or else a nonnegative duration interval in seconds.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> Typically, SFTime fields represent the number of seconds since Jan 1, 1970, 00:00:00 GMT.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> <a href="{$x3dSpecificationUrlBase}/Part01/components/time.html#Concepts" target="_blank" title="X3D Abstract Specification, Time component, 8.2 Concepts">X3D Abstract Specification, Time component, 8.2 Concepts</a>
                                            for time model, time origin, discrete and continuous changes, time-dependent node cycles and activation, pausing time, etc.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> -1 is default initial value, typically indicating no updated time value has yet been provided.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> Negative duration intervals are not allowed.
											<br />
                                            <b><font color="#447777">Hint:</font></b> Negative absolute time values are explicitly allowed and occur prior to Jan 1, 1970, 00:00:00 GMT.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> Processing an event with timestamp <code>t</code> may only result in generating events with timestamps greater than or equal to <code>t</code>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/Double-precision_floating-point_format" target="_blank">Wikipedia: Double-precision floating-point format</a>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/Time" target="_blank">Wikipedia: Time</a>,
                                            <a href="https://en.wikipedia.org/wiki/Seconds" target="_blank">Seconds</a>
                                            and
                                            <a href="https://en.wikipedia.org/wiki/System_time" target="_blank">System time</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFTime.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFTime" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFTime" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFTime.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFTime" title="MFTime bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFTimeAndMFTime" target="_blank">MFTime</a>
                                        </td>
                                        <td>
                                             Multiple-Field time array, containing an ordered list of SFTime values
                                        </td>
                                        <td>
                                            <a name="MFTime"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            −1 0 1 567890
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> -1 is the only valid negative value (indicating no actual time value is provided).
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/Double-precision_floating-point_format" target="_blank">Wikipedia: Double-precision floating-point format</a>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> see
                                            <a href="https://en.wikipedia.org/wiki/Time" target="_blank">Wikipedia: Time</a>
                                            and
                                            <a href="https://en.wikipedia.org/wiki/System_time" target="_blank">System time</a>.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFTime values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFTime.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFTime" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFTime" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFTime.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left">
                                            <a href="#SFVec2f" title="SFVec2f bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFVec2fAndMFVec2f" target="_blank">SFVec2f</a>
                                        </td>
                                        <td>
                                            Single-Field 2-tuple single-precision (32-bit)  float vector
                                        </td>
                                        <td>
                                            <a name="SFVec2f"/>
                                            Default value <b>0 0</b>.  Example values:
                                            0.5 0.5
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within attribute values are not allowed, and do not pass strict validation.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFNode.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFNode" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFVec2f" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFVec2f.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFVec2f" title="MFVec2f bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFVec2fAndMFVec2f" target="_blank">MFVec2f</a>
                                        </td>
                                        <td>
                                            Multiple-Field array of 2-tuple single-precision (32-bit) float vectors, containing an ordered list of SFVec2f values
                                        </td>
                                        <td>
                                            <a name="MFVec2f"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            0 0, 0 1, 1 1, 1 0
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within contained singleton 2-tuple SFVec2f values do not pass strict validation.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> optional comma characters between singleton 2-tuple SFVec2f attribute values can help authors keep track of long array definitions.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFVec2f values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFVec2f.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFVec2f" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFVec2f" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFVec2f.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#SFVec2d" title="SFVec2d bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFVec2dAndMFVec2d" target="_blank">SFVec2d</a>
                                        </td>
                                        <td>
                                            Single-Field 2-tuple double-precision (64-bit) float vector
                                        </td>
                                        <td>
                                            <a name="SFVec2d"/>
                                            Default value <b>0 0</b>.  Example values:
                                            0.5 0.5
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within attribute values are not allowed, and do not pass strict validation.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFVec2d.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFVec2d" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFVec2d" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFVec2d.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFVec2d" title="MFVec2d bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFVec2dAndMFVec2d" target="_blank">MFVec2d</a>
                                        </td>
                                        <td>
                                            Multiple-Field array of 2-tuple double-precision (64-bit) float vectors, containing an ordered list of SFVec2d values
                                        </td>
                                        <td>
                                            <a name="MFVec2d"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            0 0, 0 1, 1 1, 1 0
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> optional comma characters between singleton 2-tuple SFVec2d attribute values can help authors keep track of long array definitions.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within contained singleton 2-tuple SFVec2d values do not pass strict validation.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFVec2d values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFVec2d.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFVec2d" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFVec2d" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFVec2d.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left">
                                            <a href="#SFVec3f" title="SFVec3f bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFVec3fAndMFVec3f" target="_blank">SFVec3f</a>
                                        </td>
                                        <td>
                                            Single-Field 3-tuple single-precision (32-bit) float vector
                                        </td>
                                        <td>
                                            <a name="SFVec3f"/>
                                            Default value <b>0 0 0</b>.  Example values:
                                            0.0 0.0 0.0
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within attribute values are not allowed, and do not pass strict validation.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFVec3f.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFVec3f" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFVec3f" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFVec3f.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFVec3f" title="MFVec3f bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFVec3fAndMFVec3f" target="_blank">MFVec3f</a>
                                        </td>
                                        <td>
                                            Multiple-Field array of 3-tuple single-precision (32-bit) float vectors, containing an ordered list of SFVec3f values
                                        </td>
                                        <td>
                                            <a name="MFVec3f"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            0 0 0, 0 0 1, 0 1 1, 0 1 0, 1 0 0, 1 0 1, 1 1 1, 1 1 0
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> optional comma characters between singleton 3-tuple SFVec3f attribute values can help authors keep track of long array definitions.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within contained singleton 3-tuple SFVec3f values do not pass strict validation.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFVec3f values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFVec3f.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFVec3f" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFVec3f" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFVec3f.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#SFVec3d" title="SFVec3d bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFVec3dAndMFVec3d" target="_blank">SFVec3d</a>
                                        </td>
                                        <td>
                                            Single-Field 3-tuple double-precision (64-bit) float vector
                                        </td>
                                        <td>
                                            <a name="SFVec3d"/>
                                            Default value <b>0 0 0</b>.  Example values:
                                            0.0 0.0 0.0
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within attribute values are not allowed, and do not pass strict validation.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFVec3d.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFVec3d" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFVec3d" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFVec3d.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFVec3d" title="MFVec3d bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFVec3dAndMFVec3d" target="_blank">MFVec3d</a>
                                        </td>
                                        <td>
                                            Multiple-Field array of 3-tuple double-precision (64-bit) float vectors, containing an ordered list of SFVec3d values
                                        </td>
                                        <td>
                                            <a name="MFVec3d"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            0 0 0, 0 0 1, 0 1 1, 0 1 0, 1 0 0, 1 0 1, 1 1 1, 1 1 0
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> optional comma characters between singleton 3-tuple SFVec3d attribute values can help authors keep track of long array definitions.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within contained singleton 3-tuple SFVec3d values do not pass strict validation.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFVec3d values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFVec3d.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFVec3d" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFVec3d" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFVec3d.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left">
                                            <a href="#SFVec4f" title="SFVec4f bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFVec4fAndMFVec4f" target="_blank">SFVec4f</a>
                                        </td>
                                        <td>
                                            Single-Field 4-tuple single-precision (32-bit) float vector
                                        </td>
                                        <td>
                                            <a name="SFVec4f"/>
                                            Default value <b>0 0 0 1</b>.  Example values:
                                            1.0 2.0 3.0 4.0
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within attribute values are not allowed, and do not pass strict validation.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFVec4f.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFVec4f" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFVec4f" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFVec4f.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFVec4f" title="MFVec4f bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFVec4fAndMFVec4f" target="_blank">MFVec4f</a>
                                        </td>
                                        <td>
                                            Multiple-Field array of 4-tuple single-precision (32-bit) float vectors, containing an ordered list of SFVec4f values
                                        </td>
                                        <td>
                                            <a name="MFVec4f"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            1 1 1 1, 2 2 2 2, 3 3 3 3, 4 4 4 4
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> optional comma characters between singleton 4-tuple SFVec4f attribute values can help authors keep track of long array definitions.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within contained singleton 4-tuple SFVec4f values do not pass strict validation.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFVec4f values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFVec4f.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFVec4f" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFVec4f" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFVec4f.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#SFVec4d" title="SFVec4d bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFVec4dAndMFVec4d" target="_blank">SFVec4d</a>
                                        </td>
                                        <td>
                                            Single-Field 4-tuple double-precision (64-bit) float vector
                                        </td>
                                        <td>
                                            <a name="SFVec4d"/>
                                            Default value <b>0 0 0 1</b>.  Example values:
                                            1.0 2.0 3.0 4.0
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within attribute values are not allowed, and do not pass strict validation.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFVec4d.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFVec4d" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFVec4d" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFVec4d.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFVec4d" title="MFVec4d bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFVec4dAndMFVec4d" target="_blank">MFVec4d</a>
                                        </td>
                                        <td>
                                            Multiple-Field array of 4-tuple double-precision (64-bit) float vectors, containing an ordered list of SFVec4d values
                                        </td>
                                        <td>
                                            <a name="MFVec4d"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            1 1 1 1, 2 2 2 2, 3 3 3 3, 4 4 4 4
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> optional comma characters between singleton 4-tuple SFVec4d attribute values can help authors keep track of long array definitions.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within contained singleton 4-tuple SFVec4d values do not pass strict validation.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFVec4d values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFVec4d.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFVec4d" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFVec4d" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFVec4d.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left">
                                            <a href="#SFMatrix3f" title="SFMatrix3f bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFMatrix3fAndMFMatrix3f" target="_blank">SFMatrix3f</a>
                                        </td>
                                        <td>
                                            Single 3×3 matrix of single-precision (32-bit) floating point numbers
                                        </td>
                                        <td>
                                            <a name="SFMatrix3f"/>
                                            Default value <b>1 0 0 0 1 0 0 0 1</b> (which is identity matrix).
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within attribute values are not allowed, and do not pass strict validation.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFMatrix3f.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFMatrix3f" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFMatrix3f" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFMatrix3f.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFMatrix3f" title="MFMatrix3f bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFMatrix3fAndMFMatrix3f" target="_blank">MFMatrix3f</a>
                                        </td>
                                        <td>
                                            Zero or more 3×3 matrices of single-precision (32-bit) floating point numbers, containing an ordered list of SFMatrix3f values
                                        </td>
                                        <td>
                                            <a name="MFMatrix3f"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            1 0 0 0 1 0 0 0 1, 1 0 0 0 1 0 0 0 1
                                            (default value is empty list)
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> optional comma characters between singleton 9-tuple SFMatrix3f attribute values can help authors keep track of long array definitions.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within contained singleton 9-tuple SFMatrix3f values do not pass strict validation.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFMatrix3f values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFMatrix3f.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFMatrix3f" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFMatrix3f" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFMatrix3f.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#SFMatrix3d" title="SFMatrix3d bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFMatrix3dAndMFMatrix3d" target="_blank">SFMatrix3d</a>
                                        </td>
                                        <td>
                                            Single 3×3 matrix of double-precision (64-bit) floating point numbers
                                        </td>
                                        <td>
                                            <a name="SFMatrix3d"/>
                                            Default value <b>1 0 0 0 1 0 0 0 1</b> (which is identity matrix).
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within attribute values are not allowed, and do not pass strict validation.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFMatrix3d.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFMatrix3d" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFMatrix3d" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFMatrix3d.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFMatrix3d" title="MFMatrix3d bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFMatrix3dAndMFMatrix3d" target="_blank">MFMatrix3d</a>
                                        </td>
                                        <td>
                                            Zero or more 3×3 matrices of double-precision (64-bit) floating point numbers, containing an ordered list of SFMatrix3d values
                                        </td>
                                        <td>
                                            <a name="MFMatrix3d"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            1 0 0 0 1 0 0 0 1, 1 0 0 0 1 0 0 0 1
                                            (default value is empty list)
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> optional comma characters between singleton 9-tuple SFMatrix3d attribute values can help authors keep track of long array definitions.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within contained singleton 9-tuple SFMatrix3d values do not pass strict validation.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFMatrix3d values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFMatrix3d.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFMatrix3d" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFMatrix3d" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFMatrix3d.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                    <tr>
                                        <td align="left">
                                            <a href="#SFMatrix4f" title="SFMatrix4f bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFMatrix4fAndMFMatrix4f" target="_blank">SFMatrix4f</a>
                                        </td>
                                        <td>
                                            Single 4×4 matrix of single-precision (32-bit) floating point numbers
                                        </td>
                                        <td>
                                            <a name="SFMatrix4f"/>
                                            Default value <b>1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1</b> (which is identity matrix).
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within attribute values are not allowed, and do not pass strict validation.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFMatrix4f.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFMatrix4f" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFMatrix4f" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFMatrix4f.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFMatrix4f" title="MFMatrix4f bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFMatrix4fAndMFMatrix4f" target="_blank">MFMatrix4f</a>
                                        </td>
                                        <td>
                                            Zero or more 4×4 matrices of single-precision (32-bit) floating point numbers, containing an ordered list of SFMatrix4f values
                                        </td>
                                        <td>
                                            <a name="MFMatrix4f"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1, 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1
                                            (default value is empty list)
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> optional comma characters between singleton 16-tuple SFMatrix4f attribute values can help authors keep track of long array definitions.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within contained singleton 16-tuple SFMatrix4f values do not pass strict validation.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFMatrix4f values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFMatrix4f.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFMatrix4f" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFMatrix4f" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFMatrix4f.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#SFMatrix4d" title="SFMatrix4d bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFMatrix4dAndMFMatrix4d" target="_blank">SFMatrix4d</a>
                                        </td>
                                        <td>
                                            Single 4×4 matrix of double-precision (64-bit) floating point numbers
                                        </td>
                                        <td>
                                            <a name="SFMatrix4d"/>
                                            Default value <b>1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1</b> (which is identity matrix).
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within attribute values are not allowed, and do not pass strict validation.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_SFMatrix4d.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#SFMatrix4d" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#SFMatrix4d" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/SFMatrix4d.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <a href="#MFMatrix4d" title="MFMatrix4d bookmark">&#128278;</a>&#160;<a title="X3D Architecture Specification, Field type reference" href="{$x3dSpecificationUrlBase}/Part01/fieldTypes.html#SFMatrix4dAndMFMatrix4d" target="_blank">MFMatrix4d</a>
                                        </td>
                                        <td>
                                            Zero or more 4×4 matrices of double-precision (64-bit) floating point numbers, containing an ordered list of SFMatrix4d values
                                        </td>
                                        <td>
                                            <a name="MFMatrix4d"/>
                                            Default value <b>[&#160;]</b> empty list.  Example values:
                                            1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1, 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1
                                            (default value is empty list)
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> optional comma characters between singleton 16-tuple SFMatrix4d attribute values can help authors keep track of long array definitions.
                                            <br />
                                            <b><font color="#ee5500">Warning:</font></b> comma characters within contained singleton 16-tuple SFMatrix4d values do not pass strict validation.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> a single comma character is allowed as part of whitespace between individual SFMatrix4d values in the list.
                                            <br />
                                            <b><font color="#447777">Hint:</font></b> separating comma characters are not included in <a href="https://www.web3d.org/documents/specifications/19776-3/V3.3/Part03/concepts.html#X3DCanonicalForm" target="_blank">X3D canonical form</a>.
                                        </td>
                                        <td align="center">
                                            <a href="https://www.web3d.org/specifications/X3dSchemaDocumentation4.0/x3d-4.0_MFMatrix4d.html" target="_xmlschema" title="X3D XML Schema documentation">XML&#160;Schema</a>,
                                            <a href="{$x3dRegexUrl}#MFMatrix4d" target="_x3dregexes" title="X3D regexes">X3D&#160;regexes</a>,
                                            <a href="https://www.web3d.org/specifications/JavaLanguageBinding/Part2/nodeTypeInterfaces.html#MFMatrix4d" target="_javasai" title="SAI revisions in progress">Java&#160;SAI</a>,
                                            <a href="{$x3djsailDocumentationUrl}fields/MFMatrix4d.html" target="_x3djsail">X3DJSAIL</a>
                                        </td>
                                    </tr>
                                    <!-- ====================================================== -->
                                </table>
                                <p align="center">
                                    Table adapted from 
                                    <a href="https://x3dgraphics.com/chapters/Chapter01Technical_Introduction.pdf" target="_blank">Chapter 1 Technical Overview</a>,
                                    Table 1.4 <i>X3D Field Types</i>,
                                    <i><a href="https://x3dgraphics.com" target="_blank">X3D for Web Authors</a></i>,
                                    <br />
                                    Don Brutzman and Leonard Daly,
                                    Morgan Kaufman Publishers, 2007.
                                    Used with permission.                                    
                                </p>
                            </td>
                        </tr>
			<tr>
				<td colspan="3">
					<h3>
                        <!-- Unicode Character 'BOOKMARK' (U+1F516) -->
                        <a href="#credits" title="Credits and Translations">&#128278;</a>
                        <xsl:text>&#160;</xsl:text>
                        <xsl:element name="a">
                                <xsl:attribute name="name">
                                        <xsl:text>credits</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                        <xsl:text>#credits</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="title">
                                        <xsl:text>Credits and Translations</xsl:text>
                                </xsl:attribute>
                                <xsl:text>Credits and Translations</xsl:text>
                        </xsl:element>
                        <xsl:text>&#10;</xsl:text>
                                                <a href="#"><!-- top -->
                                                   <img src="icons/X3DtextIcon16.png" width="16" height="16" border="0" title="to top" alt="to top" align="right" style="vertical-align:bottom"/>
                                                </a>
                                        </h3>
					<xsl:text>Many thanks to our contributors and translators.</xsl:text>
				
			 		<ul>
						<li>	<b><a href="X3dTooltips.html">English tooltips</a></b>
							<xsl:text> (primary reference):  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:brutzman@nps.edu(Don%20Brutzman)?subject=X3D%20tooltips%20translation%20feedback%20">Don Brutzman</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> and students of the U.S. </xsl:text>
							<a href="https://www.nps.edu" target="_blank">Naval Postgraduate School (NPS)</a>
							<xsl:text> in Monterey California USA.</xsl:text>
						</li>
						<li>	<b><a href="X3dTooltipsChinese.html">Chinese tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:m17design@hotmail.com(yiqi%20meng)?subject=X3D%20tooltips%20translation%20feedback%20">yiqi meng</a>
							<xsl:text> of </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<xsl:text>Nanjing Art Institute</xsl:text>
                            <!-- originally http://m17design.myetang.com/x3d -->
							<!-- previously http://www.chinauniversity.info/2009/12/nanjing-art-institute.html -->
                            <xsl:text> in Nanjing China.</xsl:text>
						</li>
						<li>	<b><a href="X3dTooltipsFrench.html">French tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							Antony Beis,
							<a href="mailto:froussille@yahoo.com(Frederic%20Roussille)?subject=X3D%20tooltips%20translation%20feedback%20">Frederic Roussille</a>, 
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:Adrien.GRUNEISEN@wanadoo.fr(Adrien%20Gruneisen)?subject=X3D%20tooltips%20translation%20feedback%20">Adrien Gruneisen</a>
							et
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:nasayann@netcourrier.com(Yann%20Henriet)?subject=X3D%20tooltips%20translation%20feedback%20">Yann Henriet</a>
							<xsl:text>of </xsl:text>
							<a href="https://www.enit.fr" target="_blank">Ecole Nationale des Ingenieurs de Tarbes (ENIT)</a>
							<xsl:text> in Tarbes France.</xsl:text>
						</li>
						<li>	<b><a href="X3dTooltipsGerman.html">German tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:dachselt@inf.tu-dresden.de(Raimund%20Dachselt)?subject=X3D%20tooltips%20translation%20feedback%20">Raimund Dachselt</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> and </xsl:text>
							<a href="mailto:johnnyri@web.de(Johannes%20Richter)?subject=X3D%20tooltips%20translation%20feedback%20">Johannes Richter</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> of the </xsl:text>
							<a href="https://mmt.inf.tu-dresden.de" target="_blank">Multimedia Technology Group</a>
							<xsl:text>, </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="https://www.tu-dresden.de" target="_blank">Dresden University of Technology</a>
							<xsl:text> in Germany.</xsl:text>
						</li>
						<li>	<b><a href="X3dTooltipsItalian.html">Italian tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:ranon@dimi.uniud.it(Roberto%20Ranon)?subject=X3D%20tooltips%20translation%20feedback%20">Roberto Ranon</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> of the </xsl:text>
							<a href="https://www.uniud.it" target="_blank">L'Universita degli Studi di Udine</a>
							<xsl:text> in Italy.</xsl:text>
						</li>
						<li>	<b><a href="X3dTooltipsJapanese.html">Japanese tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:yeonsoo.yang@toshiba.co.jp(Yeonsoo%20Yang)?subject=X3D%20tooltips%20translation%20feedback%20">Yeonsoo Yang</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> of </xsl:text>
							<a href="https://www.toshiba.com" target="_blank">Toshiba</a>
							<xsl:text> in Japan.</xsl:text>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> (Initial draft started.) </xsl:text>
						</li>
						<li>	<b><a href="X3dTooltipsKorean.html">Korean tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:surplusz@kaist.ac.kr(Ikjune%20Kim)?subject=X3D%20tooltips%20translation%20feedback%20">Ikjune Kim</a>,
							<a href="mailto:yoo@byoo.net(Byounghyun%20Yoo)?subject=X3D%20tooltips%20translation%20feedback%20">Byounghyun Yoo</a>
                                                        and
							<a href="mailto:adpc9@partdb.com(Hyokwang%20Lee)?subject=X3D%20tooltips%20translation%20feedback%20">Hyokwang Lee</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> of the </xsl:text>
							<a href="https://www.kaist.ac.kr" target="_blank">Korea Advanced Institute of Science and Technology (KAIST)</a>
                                                        and
							<a href="http://www.partdb.com" target="_blank">PartDB Co. Ltd.</a>
							<xsl:text> in South Korea.</xsl:text>
						</li>     
						<li>	<b><a href="X3dTooltipsPortuguese.html">Portuguese tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:lsoares@lsi.usp.br(Luciano%20Pereira%20Soares)?subject=X3D%20tooltips%20translation%20feedback%20">Luciano Pereira Soares</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> of the </xsl:text>
							<a href="https://www.lsi.usp.br" target="_blank">Laborat&#211;rio de Sistemas Integr&#225;veis, Escola Polit&#233;cnica - Universidade de S&#227;o Paulo</a>
							<xsl:text> in Brasil.</xsl:text>
						</li>
						<li>	<b><a href="X3dTooltipsSpanish.html">Spanish tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:gmunoz@escet.urjc.es(Guadalupe%20Munoz%20Martin)?subject=X3D%20tooltips%20translation%20feedback%20">Guadalupe Munoz Martin</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> of </xsl:text>
							<a href="https://www.urjc.es" target="_blank">University Rey Juan Carlos</a>
							<xsl:text> in Madrid Espana.</xsl:text>
						</li>
						<li>	<b><a href="X3dTooltipsThai.html">Thai tooltips</a></b>
							<xsl:text>:  </xsl:text>
							<xsl:text>&#10;</xsl:text>
							<a href="mailto:hapztron@gmail.com(Hassadee%20Pimsuwan)?subject=X3D%20tooltips%20translation%20feedback%20">Hassadee Pimsuwan</a>
							<xsl:text>&#10;</xsl:text>
							<xsl:text> of </xsl:text>
							<a href="http://www.sut.ac.th/2012/en" target="_blank">Suranaree University of Technology</a>
                            and
							<a href="https://hassadee.com" target="_blank">hassadee.com</a>
							<xsl:text> in Thailand.</xsl:text>
						</li>
					</ul>
                
					<h3>
                                                <a href="#"><!-- top -->
                                                   <img src="icons/X3DtextIcon16.png" width="16" height="16" border="0" title="to top" alt="to top" align="right" style="vertical-align:bottom"/>
                                                </a>
                                                <xsl:element name="a">
                                                        <xsl:attribute name="name">
                                                                <xsl:text>versions</xsl:text>
                                                        </xsl:attribute>
                                                        <xsl:text>&#160;</xsl:text>
                                                </xsl:element>
						<xsl:text>Reference Tooltip Versions</xsl:text>
					</h3>
                                        
                                        <table width="100%">
                                            <tr>
                                                <td align="left">
                                                    <ul>
                                                            <li>	
                                                                <a href="README.txt">README.txt</a>
                                                            </li>
                                                            <li>	
                                                                <a href="X3dTooltips.html">X3D version 4.0 tooltips</a>
                                                               (<a href="x3d-4.0.profile.xml">.xml source</a>)
                                                            </li>
                                                            <li>	
                                                                <a href="X3dTooltips3.3.html">X3D version 3.3 tooltips</a>
                                                            </li>
                                                            <li>	
                                                                <a href="X3dTooltips3.2.html">X3D version 3.2 tooltips</a>
                                                            </li>
                                                            <li>	
                                                                <a href="X3dTooltips3.1.html">X3D version 3.1 tooltips</a>
                                                            </li>
                                                            <li>	
                                                                <a href="X3dTooltips3.0.html">X3D version 3.0 tooltips</a>
                                                            </li>
                                                    </ul>
                                                </td>
                                                <td align="right">
                                                    <a href="https://validator.w3.org/check?uri={$pageUrl}"><img src="https://www.w3.org/Icons/valid-html401" alt="Valid HTML 4.01 Transitional" height="31" width="88"/></a>
                                                </td>
                                            </tr>
                                        </table>
				</td>
			</tr>
			
		<!-- 	<tr>
				<td colspan="3">
						<xsl:text>&#160;</xsl:text>
				</td>
			</tr>
		 -->	
			<tr>
				<td align="left">
					<xsl:text>URL for these tooltips: </xsl:text>
                    <br />
                    <xsl:text>&#10;</xsl:text>
                    <xsl:text>&#160;</xsl:text><xsl:text>&#160;</xsl:text><xsl:text>&#160;</xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
                            <xsl:value-of select="$pageUrl"/>
						</xsl:attribute>
                        <xsl:value-of select="$pageUrl"/>
					</xsl:element>
				</td>
				<td>
						<xsl:text>&#160;</xsl:text>
				</td>
				<td align="right">
					<xsl:text>Tooltip source for this page: </xsl:text>
                                        <xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>.profile</xsl:text>
							<xsl:if test="($tooltipLanguage != 'English')">
								<xsl:value-of select="$tooltipLanguage"/>
							</xsl:if>
							<xsl:text>.xml</xsl:text>
						</xsl:attribute>
							<xsl:text>x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>.profile</xsl:text>
							<xsl:if test="($tooltipLanguage != 'English')">
								<xsl:value-of select="$tooltipLanguage"/>
							</xsl:if>
							<xsl:text>.xml</xsl:text>
					</xsl:element>
				</td>
                                <!--
				<td align="right">
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>https://www.web3d.org/specifications/x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>.xsd</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="target">
							<xsl:text>_blank</xsl:text>
						</xsl:attribute>
							<xsl:text>x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>.xsd</xsl:text>
					</xsl:element>
                                        <xsl:text>, </xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>https://www.web3d.org/specifications/x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>.dtd</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="target">
							<xsl:text>_blank</xsl:text>
						</xsl:attribute>
							<xsl:text>x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>.dtd</xsl:text>
					</xsl:element>
					<br />
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>https://www.web3d.org/specifications/x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>-InputOutputFields.dtd</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="target">
							<xsl:text>_blank</xsl:text>
						</xsl:attribute>
							<xsl:text>x3d-</xsl:text>
							<xsl:value-of select="$version"/>
							<xsl:text>-InputOutputFields.dtd</xsl:text>
					</xsl:element>
				</td>
                                -->
			</tr>

			<tr>
				<td align="left">
					<xsl:text>X3D Tooltips Conversion Stylesheet: </xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>X3dTooltipConversions.xslt</xsl:text>
						</xsl:attribute>
							<xsl:text>X3dTooltipConversions.xslt</xsl:text>
					</xsl:element>
				</td>
				<td>
					<xsl:text>&#160;</xsl:text>
					<!-- &#160; = &nbsp; -->
				</td>
                                <td align="right">
					<xsl:text>All tooltips: </xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>https://www.web3d.org/x3d/tooltips/X3dTooltips.zip</xsl:text>
						</xsl:attribute>
						<xsl:text>https://www.web3d.org/x3d/tooltips/X3dTooltips.zip</xsl:text>
					</xsl:element>
				</td>
			</tr>
			<tr>
				<td align="left">
					<xsl:text>Nightly build: </xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>https://savage.nps.edu/jenkins/job/X3dTooltips</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="target">
							<xsl:text>_jenkins</xsl:text>
						</xsl:attribute>
						<xsl:text>Savage Jenkins Continuous Integration Server</xsl:text>
					</xsl:element>
				</td>
				<td>
					<xsl:text>&#160;</xsl:text>
					<!-- &#160; = &nbsp; -->
				</td>
				<td align="right">
					<xsl:text>Version history: </xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>https://sourceforge.net/p/x3d/code/HEAD/tree/www.web3d.org/x3d/tooltips/</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="target">
							<xsl:text>_sourceforge</xsl:text>
						</xsl:attribute>
						<xsl:text>https://sourceforge.net/p/x3d/code/HEAD/tree/www.web3d.org/x3d/tooltips/</xsl:text>
					</xsl:element>
				</td>
			</tr>
			<tr>
				<td align="left">
					<xsl:text>Contact:</xsl:text>
					<xsl:text>&#10;</xsl:text>
					<xsl:element name="a">
						<!-- Reference:  "The mailto URL scheme"  ftp://ftp.isi.edu/in-notes/rfc2368.txt July 1998 by
						     P. Hoffman (Internet Mail Consortium), L. Masinter (Xerox Corporation), J. Zawinski (Netscape Communications) -->
						<xsl:attribute name="href">
							<xsl:text>mailto:brutzman@nps.edu(Don%20Brutzman)?subject=X3D%20Tooltips</xsl:text>
							<xsl:if test="$tooltipLanguage">
								<xsl:text>%20in%20</xsl:text>
								<xsl:value-of select="$tooltipLanguage"/>
							</xsl:if>
						</xsl:attribute>
						<xsl:attribute name="onMouseOver">
							<xsl:text>status='Click to send mail if you have comments.</xsl:text>
							<xsl:text>';return true</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="onMouseOut">
							<xsl:text>status='';return true</xsl:text>
						</xsl:attribute>
						<font color="blue">
							<xsl:text>Don Brutzman</xsl:text>
						</font>
					</xsl:element>
					<xsl:text>&#10;</xsl:text>
					
					<xsl:text> (</xsl:text>
					<xsl:element name="a">
						<!-- Reference:  "The mailto URL scheme"  ftp://ftp.isi.edu/in-notes/rfc2368.txt July 1998 by
						     P. Hoffman (Internet Mail Consortium), L. Masinter (Xerox Corporation), J. Zawinski (Netscape Communications) -->
						<xsl:attribute name="href">
							<xsl:text>mailto:brutzman@nps.edu(Don%20Brutzman)?subject=X3D%20Tooltips</xsl:text>
							<xsl:if test="$tooltipLanguage">
								<xsl:text>%20in%20</xsl:text>
								<xsl:value-of select="$tooltipLanguage"/>
							</xsl:if>
						</xsl:attribute>
						<xsl:attribute name="onMouseOver">
							<xsl:text>status='Click to send mail if you have comments.</xsl:text>
							<xsl:text>';return true</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="onMouseOut">
							<xsl:text>status='';return true</xsl:text>
						</xsl:attribute>
						<font color="blue">
							<xsl:text>brutzman&#160;at&#160;nps.edu</xsl:text>
						</font>
					</xsl:element>
					<xsl:text>)&#10;</xsl:text>
				</td>
				<td>
					<xsl:text>&#160;</xsl:text>
					<!-- &#160; = &nbsp; -->
				</td>
				<td align="right">
					<xsl:text>Generated </xsl:text>
					<xsl:value-of select="$todaysDate"/>
				</td>
			</tr>

		</table>
		</blockquote>
		
	</xsl:template>

	<!-- ****** "element" element ****************************************************** -->
	<xsl:template match="element[not(@name='USE')]">
	<!-- USE tooltip retained in profile for content correction and debugging, but it is not a valid element -->

		<!-- bookmark links row-->
		<tr align="left" valign="bottom">
                    <td bgcolor="#669999" align="right">
                            <!-- bookmark -->
                            <xsl:element name="a">
                                    <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                                    <font size="-1">
                                            <xsl:text>&#160;</xsl:text>
                                            <!-- &#160; = &nbsp; -->
                                    </font>
                            </xsl:element>
                    </td>
                    <!--m17 add here "width="600"" for word wrap 	width="600"-->
                    <td bgcolor="#669999" align="right" colspan="3">
                        <!-- bookmarks -->
                        <font size="-1" color="black">
                            <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>#accessType</xsl:text></xsl:attribute>
                                <xsl:text>accessType</xsl:text>
                            </xsl:element>
                            <xsl:text> and </xsl:text>
                            <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>#type</xsl:text></xsl:attribute>
                                <xsl:text>type</xsl:text>
                            </xsl:element>
                        </font>
                        <xsl:text>&#160;&#160;&#160;</xsl:text>
                        <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>#credits</xsl:text></xsl:attribute>
                                <font size="-1" color="black">
                                        <xsl:text>Credits and Translations</xsl:text>
                                        <!-- &#160; = &nbsp; -->
                                </font>
                        </xsl:element>
                        <xsl:text>&#160;&#160;&#160;</xsl:text>
                        <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>../content/examples/X3dResources.html</xsl:text></xsl:attribute>
                                <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
                                <font size="-1" color="black">
                                        <xsl:text>X3D Resources</xsl:text>
                                        <!-- &#160; = &nbsp; -->
                                </font>
                        </xsl:element>
                        <xsl:text>&#160;&#160;&#160;</xsl:text>
                        <!--
                        <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:text>#top</xsl:text></xsl:attribute>
                                <font size="-1" color="black">
                                        <xsl:text>to top</xsl:text>
                                </font>
                        </xsl:element>
                        <xsl:text>&#160;&#160;&#160;</xsl:text>
                        -->
                        <a href="#"><!-- top -->
                           <img src="icons/X3DtextIcon16.png" width="16" height="16" border="0" title="to top" alt="to top" align="right" style="vertical-align:bottom"/>
                        </a>
                    </td>
		</tr>
		<!--	 width="800" -->
                <xsl:variable name="urlReference">
                    <xsl:choose>
                        <xsl:when test="@name='X3D'">
                            <xsl:text>https://www.web3d.org/x3d/content/examples/X3dSceneAuthoringHints.html#Validation</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='Scene'">
                            <xsl:value-of select="$x3dSpecificationUrlBase"/>
                            <xsl:text>/Part01/concepts.html#Rootnodes</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='head'">
                            <xsl:text>https://www.web3d.org/documents/specifications/19776-1/V3.2/Part01/concepts.html#Header</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='component'">
                            <xsl:value-of select="$x3dSpecificationUrlBase"/>
                            <xsl:text>/Part01/concepts.html#Components</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='unit'">
                            <xsl:value-of select="$x3dSpecificationUrlBase"/>
                            <xsl:text>/Part01/concepts.html#Standardunitscoordinates</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='meta'">
                            <xsl:value-of select="$x3dSpecificationUrlBase"/>
                            <xsl:text>/Part01/components/core.html#METAStatement</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='ProtoDeclare'">
                            <xsl:text>https://www.web3d.org/documents/specifications/19776-1/V3.2/Part01/concepts.html#PrototypeAndFieldDeclarationSyntax</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='ProtoInterface'">
                            <xsl:text>https://www.web3d.org/documents/specifications/19776-1/V3.2/Part01/concepts.html#PrototypeAndFieldDeclarationSyntax</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='ProtoBody'">
                            <xsl:text>https://www.web3d.org/documents/specifications/19776-1/V3.2/Part01/concepts.html#PrototypeAndFieldDeclarationSyntax</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='ProtoInstance'">
                            <xsl:text>https://www.web3d.org/documents/specifications/19776-1/V3.2/Part01/concepts.html#ProtoInstanceAndFieldValueStatement</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='ExternProtoDeclare'">
                            <xsl:text>https://www.web3d.org/documents/specifications/19776-1/V3.2/Part01/concepts.html#ExternProtoDeclareStatementSyntax</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='field'">
                            <xsl:text>https://www.web3d.org/documents/specifications/19776-1/V3.2/Part01/concepts.html#PrototypeAndFieldDeclarationSyntax</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='fieldValue'">
                            <xsl:text>https://www.web3d.org/documents/specifications/19776-1/V3.2/Part01/concepts.html#ProtoInstanceAndFieldValueStatement</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='IS'">
                            <xsl:value-of select="$x3dSpecificationUrlBase"/>
                            <xsl:text>/Part01/concepts.html#PROTOdefinitionsemantics</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='connect'">
                            <xsl:text>https://www.web3d.org/documents/specifications/19776-1/V3.2/Part01/concepts.html#IS_ConnectStatementSyntax</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='IMPORT'">
                            <xsl:value-of select="$x3dSpecificationUrlBase"/>
                            <xsl:text>/Part01/components/networking.html#IMPORTStatement</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='EXPORT'">
                            <xsl:value-of select="$x3dSpecificationUrlBase"/>
                            <xsl:text>/Part01/components/networking.html#EXPORTStatement</xsl:text>
                        </xsl:when>
                        <xsl:when test="@name='ROUTE'">
                            <xsl:value-of select="$x3dSpecificationUrlBase"/>
                            <xsl:text>/Part01/concepts.html#Routes</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$x3dSpecificationUrlBase"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="$x3dSpecificationNodeIndex"/>
                            <xsl:text>#</xsl:text>
                            <xsl:value-of select="@name"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
				<xsl:variable name="cellColor">
					<xsl:choose>
						<xsl:when test="starts-with(normalize-space(@tooltip),'(X3D version 4.0 draft)') or (@name = 'X3D') or ((@name = 'version') and contains(@tooltip,'4.'))">
							<xsl:value-of select="$cellColorX3Dv4"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$cellColorNode"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
		<tr align="left">
			<td bgcolor="{$cellColor}" valign="top">
				<xsl:choose>
					<xsl:when test="@icon">
                                            <xsl:element name="a">
													<!-- each image icon links to self to encourage link reuse -->
													<xsl:attribute name="href">
														<xsl:text>#</xsl:text>
														<xsl:value-of select="@name"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="target">
                                                            <xsl:text>_blank</xsl:text>
                                                    </xsl:attribute>
                                                    <xsl:element name="img">
                                                            <xsl:attribute name="src"><xsl:value-of select="@icon"/></xsl:attribute>
                                                            <xsl:attribute name="alt"><xsl:value-of select="@name"/></xsl:attribute>
                                                            <xsl:attribute name="title"><xsl:text>reference link for this tooltip</xsl:text></xsl:attribute>
                                                    </xsl:element>
                                            </xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>&#160;&#160;&#160;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>&#10;</xsl:text>
				<xsl:if test="string-length(@name) > 18">
					<br /><!-- skip to next line, below icon -->
				</xsl:if>
				<b>
                                    <xsl:element name="font">
                                        <xsl:attribute name="color">navy</xsl:attribute>
                                        <xsl:choose>
                                          <xsl:when test="string-length(@name) > 30">
                                                <xsl:attribute name="size">-1</xsl:attribute>
                                          </xsl:when>
                                          <xsl:when test="string-length(@name) > 20">
                                                <xsl:attribute name="size">0</xsl:attribute>
                                          </xsl:when>
                                          <xsl:otherwise>
                                                <xsl:attribute name="size">+1</xsl:attribute>
                                          </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:element name="a">
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$urlReference"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="target">
                                                    <xsl:text>_blank</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="title">
                                                    <xsl:text>X3D Architecture Specification or alternate reference</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="alt">
                                                    <xsl:text>X3D Architecture Specification or alternate reference</xsl:text>
                                            </xsl:attribute>
                                            <!--
                                            -->
                                            <xsl:value-of select="@name"/>
                                        </xsl:element>
                                    </xsl:element>
				</b>
			</td>

			<!--m17 add here "width="600"" for word wrap	width="600"-->
			<td bgcolor="{$cellColor}" valign="top">
				<xsl:text>&#10;</xsl:text>
				<b>
					<font color="navy">
					<!--	<xsl:value-of select="@tooltip"/> -->
						<!-- recursive colorizing and bolding of Hint: and Warning: keywords -->
						<xsl:call-template name="highlight-HintsWarnings">
							<xsl:with-param name="inputValue" select="@tooltip"/>
						</xsl:call-template>
					</font>
				</b>
			</td>
                        
            <!-- Links to Search, X3D Schema and X3D DTD documentation -->
			<td bgcolor="{$cellColor}" valign="middle" align="center">
                            <xsl:text disable-output-escaping="yes">Search</xsl:text>
							<br />
                            <xsl:variable name="searchMailUrl">
                                <!-- https://webmasters.stackexchange.com/questions/15920/should-plus-be-encoded-in-mailto-hyperlinks -->
                                <!-- https://stackoverflow.com/questions/8940445/what-is-the-correct-way-to-escape-a-string-for-a-mailto-link -->
                                <!-- https://stackoverflow.com/questions/4228352/handling-double-quotes-in-mailto -->
                                <!-- https://www.urlencoder.org -->
                                <xsl:text>https://www.google.com/search?q=x3d+pipermail+site:web3d.org+%22</xsl:text>
                                <xsl:value-of select="@name"/>
                                <xsl:text>%22</xsl:text><!-- " character in url encoding -->
                            </xsl:variable>
                            <xsl:element name="a">
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="title">
                                    <xsl:text> Search X3D public mailing lists for </xsl:text>
                                    <xsl:value-of select="@name"/>
                                </xsl:attribute>
                                <xsl:attribute name="alt">
                                    <xsl:text> Search X3D public mailing lists for </xsl:text>
                                    <xsl:value-of select="@name"/>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$searchMailUrl"/>
                                </xsl:attribute>
								<!-- linked text -->
                                <xsl:text disable-output-escaping="yes">mail&amp;nbsp;lists</xsl:text>
                            </xsl:element>
                            <xsl:text disable-output-escaping="yes"> or </xsl:text>
							<br />
                            <xsl:element name="a">
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="title">
                                    <xsl:text> Search Mantis issues list for </xsl:text>
                                    <xsl:value-of select="@name"/>
                                    <xsl:text> (Web3D Consortium member access) </xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="alt">
                                    <xsl:text> Search Mantis issues list for </xsl:text>
                                    <xsl:value-of select="@name"/>
                                    <xsl:text> (Web3D Consortium member access) </xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$searchMantisUrl"/>
                                </xsl:attribute>
								<!-- linked text -->
                                <xsl:text disable-output-escaping="yes">Mantis&amp;nbsp;issues</xsl:text>
                            </xsl:element>
							<xsl:text>, give </xsl:text>
                            <xsl:element name="a">
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="title">
                                    <xsl:text> X3D Specification feedback options </xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="alt">
                                    <xsl:text> X3D Specification feedback options </xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:text>../content/examples/X3dResources.html#Feedback</xsl:text>
                                </xsl:attribute>
								<!-- linked text -->
                                <xsl:text disable-output-escaping="yes">feedback</xsl:text>
                            </xsl:element>
			</td>
                        
                        <!-- Links to X3D Schema and X3D DTD documentation -->
                        <xsl:variable name="componentName">
                            <xsl:choose>
                                <xsl:when test="starts-with(@name,'CAD') or contains(@name,'QuadSet')">
                                    <xsl:text>CADGeometry</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'component') or (@name = 'connect') or starts-with(@name, 'field') or
                                                (@name = 'head') or (@name = 'IS') or starts-with(@name, 'Metadata') or (@name = 'meta') or
                                                contains(@name,'Proto') or (@name = 'ROUTE') or (@name = 'Scene') or (@name = 'unit') or (@name = 'WorldInfo') or (@name = 'X3D')">
                                    <xsl:text>Core</xsl:text>
                                </xsl:when>
                                <xsl:when test="contains(@name,'CubeMap')">
                                    <xsl:text>CubeMapTexturing</xsl:text>
                                </xsl:when>
                                <xsl:when test="starts-with(@name, 'DIS') or (@name = 'EspduTransform') or contains(@name,'Pdu')">
                                    <xsl:text>DIS</xsl:text>
                                </xsl:when>
                                <xsl:when test="contains(@name, 'Background') or contains(@name, 'Fog')">
                                    <xsl:text>EnvironmentalEffects</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'ProximitySensor') or (@name = 'TransformSensor') or (@name = 'VisibilitySensor')">
                                    <xsl:text>EnvironmentalSensor</xsl:text>
                                </xsl:when>
                                <xsl:when test="contains(@name, 'Filter') or contains(@name, 'Sequencer') or contains(@name, 'Toggle') or contains(@name, 'Trigger')">
                                    <xsl:text>EventUtilities</xsl:text>
                                </xsl:when>
                                <xsl:when test="contains(@name, 'Chaser') or contains(@name, 'Damper')">
                                    <xsl:text>Followers</xsl:text>
                                </xsl:when>
                                <xsl:when test="ends-with(@name, '2D') and not(starts-with(@name,'Contour')) and not(contains(@name,'Interpolator')) and not(contains(@name,'Nurbs'))">
                                    <xsl:text>Geometry2D</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'Box') or (@name = 'Cone') or (@name = 'Cylinder') or (@name = 'ElevationGrid') or (@name = 'Extrusion') or 
                                                (@name = 'IndexedFaceSet') or (@name = 'Sphere')">
                                    <xsl:text>Geometry3D</xsl:text>
                                </xsl:when>
                                <xsl:when test="starts-with(@name, 'Geo')">
                                    <xsl:text>Geospatial</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'Group') or (@name = 'StaticGroup') or (@name = 'Switch') or (@name = 'Transform')">
                                    <xsl:text>Grouping</xsl:text>
                                </xsl:when>
                                <xsl:when test="contains(@name, 'HAnim')">
                                    <xsl:text>HAnim</xsl:text>
                                </xsl:when>
                                <xsl:when test="((@name = 'EaseInEaseOut') or contains(@name, 'Interpolator')) and not(contains(@name,'Nurbs'))">
                                    <xsl:text>Interpolation</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'KeySensor') or (@name = 'StringSensor')">
                                    <xsl:text>KeyDeviceSensor</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'Layer') or (@name = 'LayerSet') or (@name = 'Viewport')">
                                    <xsl:text>Layering</xsl:text>
                                </xsl:when>
                                <xsl:when test="starts-with(@name, 'Layout') or (@name = 'ScreenFontStyle') or (@name = 'ScreenGroup')">
                                    <xsl:text>Layout</xsl:text>
                                </xsl:when>
                                <xsl:when test="ends-with(@name, 'Light')">
                                    <xsl:text>Lighting</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'Billboard') or (@name = 'Collision') or (@name = 'LOD') or (@name = 'NavigationInfo') or contains(@name, 'Viewpoint')">
                                    <xsl:text>Navigation</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'Anchor') or (@name = 'Inline') or (@name = 'EXPORT') or (@name = 'IMPORT') or (@name = 'LoadSensor')">
                                    <xsl:text>Networking</xsl:text>
                                </xsl:when>
                                <xsl:when test="starts-with(@name, 'Contour') or (@name = 'CoordinateDouble') or starts-with(@name, 'Nurbs')">
                                    <xsl:text>NURBS</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'ParticleSystem') or contains(@name, 'Emitter') or contains(@name, 'PhysicsModel')">
                                    <xsl:text>ParticleSystems</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'PickableGroup') or contains(@name, 'PickSensor')">
                                    <xsl:text>Picking</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'CylinderSensor') or (@name = 'PlaneSensor') or (@name = 'SphereSensor') or (@name = 'TouchSensor')">
                                    <xsl:text>PointingDeviceSensor</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'ClipPlane') or starts-with(@name, 'Color') or (@name = 'Coordinate') or contains(@name, 'LineSet') or 
                                                 contains(@name, 'Triangle') or (@name = 'Normal') or (@name = 'PointSet')">
                                    <xsl:text>Rendering</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'Contact') or contains(@name, 'Joint') or starts-with(@name, 'RigidBody') or starts-with(@name, 'Collidable') or 
                                                (@name = 'CollisionCollection') or (@name = 'CollisionSensor') or (@name = 'CollisionSpace')">
                                    <xsl:text>RigidBodyPhysics</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'Script')">
                                    <xsl:text>Scripting</xsl:text>
                                </xsl:when>
                                <xsl:when test="contains(@name, 'Shader') or contains(@name, 'Vertex')">
                                    <xsl:text>Shaders</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'Appearance') or(@name = 'FillProperties') or (@name = 'LineProperties') or (@name = 'PointProperties') or contains(@name, 'Material') or (@name = 'Shape') or (@name = 'Appearance')">
                                    <xsl:text>Shape</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'AudioClip')         or (@name = 'Sound')              or (@name = 'SpatialSound')     or (@name = 'AcousticProperties') or
                                                (@name = 'Analyser')          or (@name = 'AudioDestination')   or (@name = 'BiquadFilter')     or (@name = 'BufferAudioSource')  or
                                                (@name = 'ChannelMerger')     or (@name = 'ChannelSelector')    or (@name = 'ChannelSplitter')  or (@name = 'Convolver') or
                                                (@name = 'Delay')             or (@name = 'DynamicsCompressor') or (@name = 'Gain')             or (@name = 'ListenerPointSource') or
                                                (@name = 'MicrophoneSource')  or (@name = 'OscillatorSource')   or (@name = 'PeriodicWave')     or (@name = 'StreamAudioDestination') or
                                                (@name = 'StreamAudioSource') or (@name = 'WaveShaper')">
                                    <xsl:text>Sound</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'FontStyle') or (@name = 'Text')">
                                    <xsl:text>Text</xsl:text>
                                </xsl:when>
                                <xsl:when test="contains(@name, 'Texture') and (contains(@name, '3D') or contains(@name, '4D'))">
                                    <xsl:text>Texturing3D</xsl:text>
                                </xsl:when>
                                <xsl:when test="contains(@name, 'Texture') and not(contains(@name, 'NURBS'))"><!-- must follow Texturing3D -->
                                    <xsl:text>Texturing</xsl:text>
                                </xsl:when>
                                <xsl:when test="(@name = 'TimeSensor')">
                                    <xsl:text>Time</xsl:text>
                                </xsl:when>
                                <xsl:when test="contains(@name, 'Volume')">
                                    <xsl:text>VolumeRendering</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:message>
                                        <xsl:text>componentName not found for </xsl:text>
                                        <xsl:value-of select="@name"/>
                                        <xsl:text> node!</xsl:text>
                                    </xsl:message>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:text></xsl:text>
                        </xsl:variable>
			<td bgcolor="{$cellColor}" valign="middle" align="center">
                            <xsl:text disable-output-escaping="yes">X3D&amp;nbsp;validation:</xsl:text>
                            <br />
                            <!-- https://www.web3d.org/specifications/X3dSchemaDocumentation3.3/x3d-3.3_Layer.html -->
                            <xsl:variable name="schemaDocumentationUrl">
                                <xsl:text>https://www.web3d.org/specifications/X3dSchemaDocumentation</xsl:text>
                                <xsl:value-of select="$version"/>
                                <xsl:text>/x3d-</xsl:text>
                                <xsl:value-of select="$version"/>
                                <xsl:text>_</xsl:text>
                                <xsl:value-of select="@name"/>
                                <xsl:text>.html</xsl:text>
                            </xsl:variable>
                            <xsl:element name="a">
                                <xsl:attribute name="target">
                                    <xsl:text>_schema</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="title">
                                    <xsl:text>X3D XML Schema documentation for </xsl:text>
                                    <xsl:value-of select="@name"/>
                                </xsl:attribute>
                                <xsl:attribute name="alt">
                                    <xsl:text>X3D XML Schema documentation for </xsl:text>
                                    <xsl:value-of select="@name"/>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$schemaDocumentationUrl"/>
                                </xsl:attribute>
                                <xsl:text disable-output-escaping="yes">XML&amp;nbsp;Schema</xsl:text>
                            </xsl:element>
                            <xsl:text disable-output-escaping="yes">, </xsl:text>
                            <!-- https://www.web3d.org/specifications/X3dDoctypeDocumentation3.3.html#AudioClip -->
                            <xsl:variable name="doctypeDocumentationUrl">
                                <xsl:text>https://www.web3d.org/specifications/X3dDoctypeDocumentation</xsl:text>
                                <xsl:value-of select="$version"/>
                                <xsl:text>.html#</xsl:text>
                                <xsl:value-of select="@name"/>
                            </xsl:variable>
                            <xsl:element name="a">
                                <xsl:attribute name="target">
                                    <xsl:text>_dtd</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="title">
                                    <xsl:text>X3D DOCTYPE documentation for </xsl:text>
                                    <xsl:value-of select="@name"/>
                                </xsl:attribute>
                                <xsl:attribute name="alt">
                                    <xsl:text>X3D DOCTYPE documentation for </xsl:text>
                                    <xsl:value-of select="@name"/>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$doctypeDocumentationUrl"/>
                                </xsl:attribute>
                                <xsl:text disable-output-escaping="yes">DOCTYPE</xsl:text>
                            </xsl:element>
                            <xsl:text>, </xsl:text>
                            <!-- https://www.web3d.org/specifications/X3dJsonSchemaDocumentation3.3/x3d-3.3-JSONSchema_AudioClip.html -->
                            <xsl:variable name="jsonDocumentationUrl">
                                <xsl:text>https://www.web3d.org/specifications/X3dJsonSchemaDocumentation</xsl:text>
                                <!-- TODO <xsl:value-of select="$version"/> -->
                                <xsl:text>3.3</xsl:text>
                                <xsl:text>/x3d-</xsl:text>
                                <!-- TODO <xsl:value-of select="$version"/> -->
                                <xsl:text>3.3</xsl:text>
                                <xsl:text>-JSONSchema_</xsl:text>
                                <xsl:value-of select="@name"/>
                                <xsl:text>.html</xsl:text>
                            </xsl:variable>
                            <xsl:element name="a">
                                <xsl:attribute name="target">
                                    <xsl:text>_json</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="title">
                                    <xsl:text>X3D JSON Schema documentation for </xsl:text>
                                    <xsl:value-of select="@name"/>
                                </xsl:attribute>
                                <xsl:attribute name="alt">
                                    <xsl:text>X3D JSON Schema documentation for </xsl:text>
                                    <xsl:value-of select="@name"/>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$jsonDocumentationUrl"/>
                                </xsl:attribute>
                                <xsl:text disable-output-escaping="yes">JSON&amp;nbsp;Schema</xsl:text>
                            </xsl:element>
                            <xsl:if test="(string-length($componentName) > 0)">
                                <xsl:text>, </xsl:text>
                                <xsl:element name="a">
                                    <xsl:attribute name="target">
                                        <xsl:text>_javasai</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="title">
                                        <xsl:text>Java SAI documentation for </xsl:text>
                                        <xsl:value-of select="@name"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="alt">
                                        <xsl:text>Java SAI documentation for </xsl:text>
                                        <xsl:value-of select="@name"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="$javaSaiDocumentationUrl"/>
                                        <xsl:text>#</xsl:text>
                                        <xsl:value-of select="@name"/>
                                    </xsl:attribute>
                                    <xsl:text disable-output-escaping="yes">Java&amp;nbsp;SAI</xsl:text>
                                </xsl:element>
                                <xsl:text>, </xsl:text>
                                <xsl:element name="a">
                                    <xsl:attribute name="target">
                                        <xsl:text>_x3djsail</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="title">
                                        <xsl:text>X3DJSAIL Java documentation for </xsl:text>
                                        <xsl:value-of select="@name"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="alt">
                                        <xsl:text>X3DJSAIL Java documentation for </xsl:text>
                                        <xsl:value-of select="@name"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="$x3djsailDocumentationUrl"/>
                                        <xsl:value-of select="$componentName"/>
                                        <xsl:text>/</xsl:text>
                                        <xsl:value-of select="@name"/>
                                        <xsl:text>.html</xsl:text>
                                    </xsl:attribute>
                                    <xsl:text disable-output-escaping="yes">X3DJSAIL</xsl:text>
                                </xsl:element>
                            </xsl:if>
			</td>
		</tr>

		<xsl:apply-templates select="attribute"/>
        
        <!-- HTML5/DOM permissive interoperability -->
        <xsl:if test="not(@name = 'Anchor')">
            <xsl:apply-templates select="//element[@name='Anchor']/attribute[@name='class']"/>
            <xsl:apply-templates select="//element[@name='Anchor']/attribute[@name='id']"/>
            <xsl:if test="not(@name = 'FontStyle') and not(@name = 'ScreenFontStyle')">
                <xsl:apply-templates select="//element[@name='Anchor']/attribute[@name='style']"/>
            </xsl:if>
        </xsl:if>
		
	</xsl:template>

	<!-- ****** "attribute" element****************************************************** -->
	<xsl:template match="attribute">

		<!-- error checking -->
		<xsl:variable name="attributeName" select="@name"/>
		<xsl:if test="(not(../@name = 'Anchor') and (($attributeName = 'class') or ($attributeName = 'id') or ($attributeName = 'style'))) and
                      (not((../@name = 'FontStyle') or (../@name = 'ScreenFontStyle')) and ($attributeName = 'style'))">
			<xsl:message>
				<xsl:text>[Error] element '</xsl:text>
				<xsl:value-of select="../@name"/>
				<xsl:text>' attribute '</xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>' has duplicate entry (simply refer to Anchor/</xsl:text>
                <xsl:value-of select="@name"/>
				<xsl:text> instead</xsl:text>
			</xsl:message>
		</xsl:if>
		<xsl:if test="(count(preceding-sibling::*[@name = $attributeName]) > 0)">
			<xsl:message>
				<xsl:text>[Error] element '</xsl:text>
				<xsl:value-of select="../@name"/>
				<xsl:text>' attribute '</xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>' has duplicate entry</xsl:text>
			</xsl:message>
		</xsl:if>
		<xsl:if test="not(contains(@tooltip,concat('[',@name,' '))) and 
                              not(contains(@tooltip,concat('[X3D statement #',@name,']')))">
			<xsl:message>
				<xsl:text>[Error] element '</xsl:text>
				<xsl:value-of select="../@name"/>
				<xsl:text>' attribute '</xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>' does not start with matching name in tooltip</xsl:text>
			</xsl:message>
		</xsl:if>
		<xsl:if test="contains(@tooltip,'[') and not(contains(@tooltip,']'))">
			<xsl:message>
				<xsl:text>[Error] element '</xsl:text>
				<xsl:value-of select="../@name"/>
				<xsl:text>' attribute '</xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>' has unmatched [ bracket</xsl:text>
			</xsl:message>
		</xsl:if>
		<xsl:if test="contains(@tooltip,']') and not(contains(@tooltip,'['))">
			<xsl:message>
				<xsl:text>[Error] element '</xsl:text>
				<xsl:value-of select="../@name"/>
				<xsl:text>' attribute '</xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>' has unmatched ] bracket</xsl:text>
			</xsl:message>
		</xsl:if>
		<xsl:variable name="signatureSummary">
			<xsl:choose>
				<!-- three bracketed entries-->
				<xsl:when test="contains(substring-after(@tooltip,']'),'] [')">
					<!-- debug
					<xsl:message>
						<xsl:text>signatureSummary triple brackets.. </xsl:text>
						<xsl:value-of select="substring-before(@tooltip,(tokenize(@tooltip,'\]')[last()]))"/>
						<xsl:text>]</xsl:text>
					</xsl:message>
					-->
					<xsl:value-of select="substring-before(@tooltip,(tokenize(@tooltip,'\]')[last()]))"/>
					<xsl:text>]</xsl:text>
					<!-- <xsl:value-of select="concat(substring-before(substring-after(substring-after(@tooltip,']'),']'),']'),']',substring-before(substring-after(substring-after(@tooltip,']'),']'),']'))"/> -->
				</xsl:when>
				<!-- TODO handle ] ( -->
				<xsl:when test="contains(@tooltip,',+&#8734;)')"><!-- infinity range -->
					<!-- debug
					<xsl:message>
						<xsl:text>signatureSummary bracket, infin).. </xsl:text>
						<xsl:value-of select="concat(substring-before(@tooltip,']'),']',substring-before(substring-after(@tooltip,']'),'+&#8734;)'))"/>
						<xsl:text>+&#8734;)</xsl:text>
					</xsl:message>
					-->
						<xsl:value-of select="concat(substring-before(@tooltip,']'),']',substring-before(substring-after(@tooltip,']'),'+&#8734;)'))"/>
						<xsl:text>+&#8734;)</xsl:text>
				</xsl:when>
				<xsl:when test="contains(@tooltip,',1)')"><!-- infinity range -->
					<!-- debug
					<xsl:message>
						<xsl:text>signatureSummary bracket, 1).. </xsl:text>
						<xsl:value-of select="concat(substring-before(@tooltip,']'),']',substring-before(substring-after(@tooltip,']'),'1)'))"/>
						<xsl:text>1)</xsl:text>
					</xsl:message>
					-->
						<xsl:value-of select="concat(substring-before(@tooltip,']'),']',substring-before(substring-after(@tooltip,']'),'1)'))"/>
						<xsl:text>1)</xsl:text>
				</xsl:when>
				<xsl:when test="starts-with(@tooltip,'[X3D version ') or contains(@tooltip,'] [') or contains(@tooltip,'] (')">
					<!-- debug
					<xsl:message>
						<xsl:text>signatureSummary double brackets.. </xsl:text>
						<xsl:value-of select="concat(substring-before(@tooltip,']'),']',substring-before(substring-after(@tooltip,']'),']'))"/>
						<xsl:text>]</xsl:text>
					</xsl:message>
					-->
					    <xsl:value-of select="concat(substring-before(@tooltip,']'),']',substring-before(substring-after(@tooltip,']'),']'))"/>
						<xsl:text>]</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<!-- debug
					<xsl:message>
						<xsl:text>signatureSummary single bracket... </xsl:text>
						<xsl:value-of select="concat(substring-before(@tooltip,']'),']')"/>
					</xsl:message>
					-->
					    <xsl:value-of select="concat(substring-before(@tooltip,']'),']')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
        <!-- TODO improved form of limits when -1 sentinel is part of index
		<xsl:variable name="signatureSummary">
			<xsl:choose>
				<xsl:when test="contains(@tooltip,'] or -1')">
					<xsl:value-of select="substring-before(@tooltip,']')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-before(@tooltip,']')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		-->
		<xsl:if test="$signatureSummary and not(@name='DEF') and not(@name='USE') and not(@name='class') and not(@name='id') and 
                     (not(@name='style') and (not((../@name = 'FontStyle') or (../@name = 'ScreenFontStyle')) and ($attributeName = 'style'))) and
                      not(@name='containerField') and not(../@name='component') and not(../@name='connect') and not(../@name='field') and
                      not(../@name='fieldValue') and not(../@name='meta') and not(../@name='IMPORT') and not(../@name='EXPORT') and
                      not(../@name='ExternProtoDeclare') and not(../@name='ProtoDeclare') and not(../@name='ProtoInstance') and
                      not(../@name='ROUTE') and not(../@name='unit')and not(../@name='X3D') and not(../@name='XvlShell') and
                      not(@name='component') and not(@name='unit') and not(@name='meta') and not(@name='connect') and
                      not(@name='field') and not(@name='fieldValue')">
			<xsl:if test="not(contains($signatureSummary,'initializeOnly')) and not(contains($signatureSummary,'inputOnly')) and not(contains($signatureSummary,'outputOnly')) and not(contains($signatureSummary,'inputOutput'))">
				<xsl:message>
					<xsl:text>[Error] element '</xsl:text>
					<xsl:value-of select="../@name"/>
					<xsl:text>' attribute '</xsl:text>
					<xsl:value-of select="@name"/>
					<xsl:text>' is missing accessType information</xsl:text>
				</xsl:message>
			</xsl:if>
			<!-- note that character entities are replaced during parsing prior to applying this test, so no ampersands are included -->
			<xsl:if test="not(contains($signatureSummary,'SF')) and not(contains($signatureSummary,'MF')) and not(contains($signatureSummary,'CDATA')) and not(contains($signatureSummary,'IDREF')) and not(contains($signatureSummary,'NMTOKEN')) and not(contains($signatureSummary,'xs:token')) and not(contains($signatureSummary,'(') and contains($signatureSummary,')'))">
				<xsl:message>
					<xsl:text>[Error] element '</xsl:text>
					<xsl:value-of select="../@name"/>
					<xsl:text>' attribute '</xsl:text>
					<xsl:value-of select="@name"/>
					<xsl:text>' is missing type information</xsl:text>
				</xsl:message>
			</xsl:if>
		</xsl:if>
		<xsl:variable name="cellColor">
			<xsl:choose>
				<xsl:when test="starts-with($signatureSummary,'(X3D version 4.0 draft)') or starts-with(normalize-space(../@tooltip),'(X3D version 4.0 draft)') or (@name = 'X3D') or ((@name = 'version') and contains(@tooltip,'4.'))">
					<xsl:value-of select="$cellColorX3Dv4"/>
				</xsl:when>
				<xsl:when test="contains($signatureSummary,'type SFNode') or contains($signatureSummary,'type MFNode') or (@name = 'field') or (@name = 'fieldValue') or (@name = 'ProtoInterface') or (@name = 'ProtoBody') or (@name = 'IS') or (@name = 'connect')">
					<xsl:value-of select="$cellColorNodeField"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$cellColorAttribute"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- new row  width="800"-->
		<tr align="left">
				
			<td bgcolor="{$cellColor}" align="left" valign="top">
				<!-- &#160;&#160;&#160;&#160;&#160;&#160; <xsl:text>&#160;</xsl:text>-->
				
				<!-- field element/attribute bookmark -->
				<xsl:element name="a">
					<xsl:attribute name="name">
						<xsl:value-of select="../@name"/>
						<xsl:text>.</xsl:text>
						<xsl:value-of select="@name"/>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:if test="contains($signatureSummary,'(X3D version 4.0 draft)') or starts-with(normalize-space(../@tooltip),'(X3D version 4.0 draft)')">
							<xsl:text>(X3D version 4.0 draft) </xsl:text>
						</xsl:if>
						<xsl:value-of select="@name"/>
						<xsl:choose>
							<xsl:when test="contains($signatureSummary,'type SFNode')">
								<xsl:text> field is a contained SFNode element that has containerField=&apos;</xsl:text>
								<xsl:value-of select="@name"/>
								<xsl:text>&apos;</xsl:text>
							</xsl:when>
							<xsl:when test="contains($signatureSummary,'type MFNode')">
								<xsl:text> field is a contained MFNode array, each element has containerField=&apos;</xsl:text>
								<xsl:value-of select="@name"/>
								<xsl:text>&apos;</xsl:text>
							</xsl:when>
							<xsl:when test="(@name = 'DEF') or (@name = 'USE') or (@name = 'containerField') or (@name = 'class') or (@name = 'id')">
								<xsl:text> is an XML attribute</xsl:text>
							</xsl:when>
							<xsl:when test="(@name = 'field') or (@name = 'fieldValue') or (@name = 'ProtoInterface') or (@name = 'ProtoBody') or (@name = 'IS') or (@name = 'connect')">
								<xsl:text> is a contained X3D statement</xsl:text>
							</xsl:when>
							<xsl:when test="(@name = 'nodeField') or (@name = 'protoField') or (@name = 'inlineDEF') or (@name = 'importedDEF') or (@name = 'AS') or (@name = 'localDEF')">
								<xsl:text> is an XML attribute</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text> is an X3D field</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<!-- each field/attribute links to self to encourage link reuse -->
					<xsl:attribute name="href">
						<xsl:text>#</xsl:text>
						<xsl:value-of select="../@name"/>
						<xsl:text>.</xsl:text>
						<xsl:value-of select="@name"/>
					</xsl:attribute>
					<!-- &#160; = &nbsp; -->
					<xsl:if test="@name">
						<b>
						<xsl:element name="font">
							<xsl:attribute name="color">black</xsl:attribute>
							<xsl:choose>
							  <xsl:when test="string-length(@name) > 20">
								<xsl:attribute name="size">-1</xsl:attribute>
							  </xsl:when>
							  <xsl:when test="string-length(@name) > 15">
								<xsl:attribute name="size">0</xsl:attribute>
							  </xsl:when>
							  <xsl:when test="string-length(@name) > 10">
								<xsl:attribute name="size">1</xsl:attribute>
							  </xsl:when>
							  <xsl:otherwise>
								<xsl:attribute name="size">2</xsl:attribute>
							  </xsl:otherwise>
							</xsl:choose>
							<xsl:value-of select="@name"/>
						</xsl:element>
						</b>
					</xsl:if>
				</xsl:element>
			</td>

			<td bgcolor="{$cellColor}" colspan="3">
				<xsl:if test="starts-with(normalize-space($signatureSummary),'(X3D version 4.0 draft)')">
					<b>
						<xsl:text> (</xsl:text>
						<a href="https://www.web3d.org/x3d4" target="_blank"><font color="black">X3D version 4.0 draft</font></a>
						<xsl:text>) </xsl:text>
					</b>
				</xsl:if>
				<xsl:variable name="AttributeSpecification">
                                    <xsl:choose>
                                        <xsl:when test="contains(@tooltip,']')">
                                            <xsl:variable name="initialSubstringBeforeSquareBracket">
												<xsl:value-of select="$signatureSummary"/>
                                                <!--
												<xsl:choose>
                                                    < ! - - handle case where nested ] characters appear, such as case when outputOnly has range restriction, e.g. LoadSensor progress - - >
                                                	<xsl:when test="contains(@tooltip,'allowed range')">
                                                        <xsl:value-of select="concat(substring-before(@tooltip,']'),']',substring-before(substring-after(@tooltip,']'),']'))"/>< ! - - second bracket - - >
                                                    </xsl:when>
													<xsl:when test="contains(@tooltip,'#FIXED &#34;&#34;]')">
                                                        <xsl:value-of select="substring-before(@tooltip,'#FIXED &#34;&#34;]')"/>
                                                        <xsl:text disable-output-escaping="yes">#FIXED &#34;&#34;</xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                         <xsl:value-of select="substring-before(@tooltip,']')"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                -->
                                            </xsl:variable>
                                            <xsl:value-of select="$signatureSummary"/>
											
                                            <!-- also get attribute value bounds [0,infinity) [0,1] etc.,  if any -->
                                            <xsl:variable name="nextSubstring">
                                                <xsl:value-of select="(substring-after(@tooltip,concat($initialSubstringBeforeSquareBracket,'')))"/>
                                            </xsl:variable>
                                            <xsl:variable name="positionCloseBracket"     select="string-length(substring-before($nextSubstring,']'))+1"/>
                                            <xsl:variable name="positionCloseParenthesis" select="string-length(substring-before($nextSubstring,')'))+1"/>
                                            <!-- good test cases: orthogonalColor vertexCount -->
                                            <!-- attribute tooltip: quadruple diagnostics
                                            <xsl:if test="(@name='cycleInterval')">
                                                <xsl:message>
                                                    <xsl:value-of select="../@name"/>
                                                    <xsl:text> </xsl:text>
                                                    <xsl:value-of select="@name"/>
                                                    <xsl:text> $initialSubstringBeforeSquareBracket=</xsl:text>
                                                    <xsl:value-of select="$initialSubstringBeforeSquareBracket"/>
                                                    <xsl:text>, $nextSubstring=</xsl:text>
                                                    <xsl:value-of select="$nextSubstring"/>
                                                    <xsl:text>,&#10;</xsl:text>
                                                    <xsl:text>   $positionCloseBracket=</xsl:text>
                                                    <xsl:value-of select="$positionCloseBracket"/>
                                                    <xsl:text>, $positionCloseParenthesis=</xsl:text>
                                                    <xsl:value-of select="$positionCloseParenthesis"/>
                                                </xsl:message>
                                            </xsl:if>
                                            -->
                                            <!-- signature summary may immediately be followed by a value constraint, e.g. range interval, or node (or X3DNodeType) restriction -->
                                            <xsl:if test="starts-with(normalize-space($nextSubstring),'(') or starts-with(normalize-space($nextSubstring),'[')">
                                                <!-- range interval -->
                                                <xsl:choose>
                                                    <xsl:when test="contains($nextSubstring,' or -1.')">
                                                        <xsl:text> </xsl:text> <!-- must match in follow-on test, thus single space is required in .xml file between ] [ brackets! -->
                                                        <xsl:value-of select="normalize-space(substring-before($nextSubstring,' or -1.'))"/>
                                                        <xsl:text> or -1.</xsl:text>
                                                    </xsl:when>
                                                    <!-- don't bind ] if ) appears first, e.g. vertexCount -->
                                                    <xsl:when test="contains($nextSubstring,']') and (($positionCloseParenthesis > $positionCloseBracket) or not($positionCloseParenthesis > 0))">
                                                        <xsl:text> </xsl:text> <!-- must match in follow-on test, thus single space is required in .xml file between ] [ brackets! -->
                                                        <xsl:value-of select="normalize-space(substring-before($nextSubstring,']'))"/>
                                                        <xsl:text>]</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="contains($nextSubstring,')')">
                                                        <xsl:text> </xsl:text> <!-- must match in follow-on test, thus single space is required in .xml file between ] [ brackets! -->
                                                        <xsl:value-of select="normalize-space(substring-before($nextSubstring,')'))"/>
                                                        <xsl:text>)</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test="contains($nextSubstring,']')">
                                                        <xsl:text> </xsl:text> <!-- must match in follow-on test, thus single space is required in .xml file between ] [ brackets! -->
                                                        <xsl:value-of select="normalize-space(substring-before($nextSubstring,']'))"/>
                                                        <xsl:text>]</xsl:text>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="normalize-space(@tooltip)"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
				</xsl:variable>
                                <!-- attribute tooltip: quadruple diagnostics
                                <xsl:if test="(@name='cycleInterval')">
                                    <xsl:message>
                                        <xsl:value-of select="../@name"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="@name"/>
                                        <xsl:text> normalize-space($AttributeSpecification)=</xsl:text>
                                        <xsl:value-of select="normalize-space($AttributeSpecification)"/>
                                    </xsl:message>
                                </xsl:if>
                                -->
                                <xsl:choose>
                                    <!-- special handling of pseudo-attribute for X3D head,Scene etc. -->
                                    <xsl:when test="starts-with($AttributeSpecification,'[X3D statement #')">
                                        <b>
                                            <font color="black"><xsl:text>[X3D statement </xsl:text></font>
                                            <xsl:variable name="elementName" select="normalize-space(substring-before(substring-after($AttributeSpecification,'[X3D statement #'),']'))"/>
                                            <xsl:element name="a">
                                                <xsl:attribute name="href">
                                                    <xsl:text>#</xsl:text>
                                                    <xsl:value-of select="$elementName"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="$elementName"/>
                                            </xsl:element>
                                            <font color="black"><xsl:text>] </xsl:text></font>
                                        </b>
                                        <br />
                                    </xsl:when>
                                    <!-- accessType bookmark -->
                                    <xsl:when test="contains($AttributeSpecification,'type')">
                                        <xsl:variable name="initialString">
											<xsl:choose>
												<xsl:when test="contains($AttributeSpecification,'accessType')">
													<xsl:value-of select="substring-before($AttributeSpecification,'accessType')"/>
												</xsl:when>
												<xsl:when test="contains($AttributeSpecification,'type')">
													<xsl:value-of select="substring-before($AttributeSpecification,'type')"/>
												</xsl:when>
											</xsl:choose>
										</xsl:variable>
                                        <xsl:variable name="accessTypeValue" select="substring-before(substring-after($AttributeSpecification,'accessType '),',')"/>
                                        
                                        <b>
											<xsl:choose>
												<xsl:when test="starts-with(normalize-space($initialString),'(X3D version 4.0 draft)')">
													<xsl:value-of select="substring-after($initialString,'(X3D version 4.0 draft)')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$initialString"/>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:if test="contains($AttributeSpecification,'accessType')">
												<xsl:element name="a">
													<xsl:attribute name="href">
														<xsl:text>#accessType</xsl:text>
													</xsl:attribute>
                                                                                                        <xsl:attribute name="title">
                                                                                                            <xsl:choose>
                                                                                                                <xsl:when test="($accessTypeValue = 'initializeOnly')">
                                                                                                                        <xsl:text>initializable field that does not send or receive events at run time</xsl:text>
                                                                                                                </xsl:when>
                                                                                                                <xsl:when test="($accessTypeValue = 'inputOutput')">
                                                                                                                        <xsl:text>initializable field that can send or receive events at run time</xsl:text>
                                                                                                                </xsl:when>
                                                                                                                <xsl:when test="($accessTypeValue = 'inputOnly')">
                                                                                                                        <xsl:text>input field that can only receive events at run time</xsl:text>
                                                                                                                </xsl:when>
                                                                                                                <xsl:when test="($accessTypeValue = 'outputOnly')">
                                                                                                                        <xsl:text>output field that can only receive events at run time</xsl:text>
                                                                                                                </xsl:when>
                                                                                                            </xsl:choose>
                                                                                                        </xsl:attribute>
													<xsl:text>accessType </xsl:text>
													<xsl:value-of select="$accessTypeValue"/>
												</xsl:element>
												<xsl:text>, </xsl:text>
											</xsl:if>
                                            <!-- now get type; watch out for attributes named 'type' by first skipping after 'accessType'  -->
                                            <xsl:variable name="typeValue">
												<xsl:choose>
													<xsl:when test="contains($AttributeSpecification,'accessType')">
														<xsl:value-of select="substring-before(substring-after(substring-after($AttributeSpecification,'accessType '),'type '),' ')"/>
													</xsl:when>
													<xsl:when test="contains($AttributeSpecification,'type')">
														<xsl:value-of select="substring-before(substring-after($AttributeSpecification,'type '),' ')"/>
													</xsl:when>
												</xsl:choose>
											</xsl:variable>
                                            
                                            <!-- attribute tooltip: quadruple diagnostics
                                            <xsl:if test="(@name='vertexCount')">
                                                <xsl:message>
                                                    <xsl:text>$accessTypeValue=</xsl:text>
                                                    <xsl:value-of select="$accessTypeValue"/>
                                                </xsl:message>
                                                <xsl:message>
                                                    <xsl:text>$typeValue=</xsl:text>
                                                    <xsl:value-of select="$typeValue"/>
                                                </xsl:message>
                                            </xsl:if>
                                            -->
                                            <xsl:element name="a">
                                                <xsl:attribute name="href">
                                                    <xsl:choose>
                                                        <xsl:when test="starts-with($typeValue,'MF') or starts-with($typeValue,'SF')">
                                                            <xsl:text>#</xsl:text>
                                                            <xsl:value-of select="$typeValue"/>
                                                        </xsl:when>
                                                        <xsl:when test="contains($typeValue,'IDREF')">
                                                            <xsl:text>#IDREF</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="contains($typeValue,'ID')">
                                                            <xsl:text>#ID</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="contains($typeValue,'NMTOKENS')">
                                                            <xsl:text>#NMTOKENS</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="contains($typeValue,'NMTOKEN')">
                                                            <xsl:text>#NMTOKEN</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="contains($typeValue,'xs:token')">
                                                            <xsl:text>#xs:token</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="contains($typeValue,'CDATA')">
                                                            <xsl:text>#CDATA</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="contains($typeValue,'ENUMERATION')">
                                                            <xsl:text>#ENUMERATION</xsl:text>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:text>#type</xsl:text>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:attribute name="title">
                                                    <xsl:choose>
                                                        <xsl:when test="contains($typeValue,'IDREF')">
                                                            <xsl:text>IDREF means Identifier Reference name token</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="contains($typeValue,'ID')">
                                                            <xsl:text>ID means Identifier  name token</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="contains($typeValue,'NMTOKEN')">
                                                            <xsl:text>Name Token</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="contains($typeValue,'xs:token')">
                                                            <xsl:text>Token (may contain whitespace)</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="contains($typeValue,'ENUMERATION')">
                                                            <xsl:text>Enumeration Name Token</xsl:text>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:choose>
                                                                <xsl:when test="starts-with($typeValue,'SFNode')">
                                                                        <xsl:text>Single-Field node </xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="starts-with($typeValue,'MFNode')">
                                                                        <xsl:text>Multi-Field node array </xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="starts-with($typeValue,'SF')">
                                                                        <xsl:text>Single-Field </xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="starts-with($typeValue,'MF')">
                                                                        <xsl:text>Multi-Field array </xsl:text>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                            <xsl:choose>
                                                                <xsl:when test="contains($typeValue,'Bool')">
                                                                        <xsl:text>boolean </xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains($typeValue,'Float')">
                                                                        <xsl:text>float </xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains($typeValue,'Int32')">
                                                                        <xsl:text>integer </xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains($typeValue,'String')">
                                                                        <xsl:text>string </xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains($typeValue,'Time')">
                                                                        <xsl:text>time (clock or duration) </xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains($typeValue,'2')">
                                                                        <xsl:text>2-tuple </xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains($typeValue,'3') or ends-with($typeValue,'Color')">
                                                                        <xsl:text>3-tuple </xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="contains($typeValue,'4') or contains($typeValue,'Rotation') or ends-with($typeValue,'ColorRGBA')">
                                                                        <xsl:text>4-tuple </xsl:text>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                            <xsl:if test="contains($typeValue,'Vec')">
                                                                <xsl:text>vector </xsl:text>
                                                            </xsl:if>
                                                            <xsl:text>value</xsl:text>
                                                            <xsl:choose>
                                                                <xsl:when test="contains($typeValue,'Int32')">
                                                                        <xsl:text>, 32-bit precision</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="ends-with($typeValue,'f')">
                                                                        <xsl:text>, single-precision 32-bit floating point</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="ends-with($typeValue,'d')">
                                                                        <xsl:text>, double-precision 64-bit floating point</xsl:text>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                            <!-- too verbose
                                                            <xsl:text> (schema validation)</xsl:text>
                                                            -->
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:text>type </xsl:text>
                                                <xsl:value-of select="$typeValue"/>
                                            </xsl:element>
                                            <xsl:text> </xsl:text>
                                            <xsl:call-template name="xml-attribute-reference-bookmarks">
                                                <xsl:with-param name="inputValue">
                                                    <xsl:value-of select="normalize-space(substring-after($AttributeSpecification,$typeValue))"/>
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </b>
                                        <br />
                                    </xsl:when>
                                    <xsl:when test="$AttributeSpecification">
                                        <b>
                                            <xsl:call-template name="xml-attribute-reference-bookmarks">
                                                <xsl:with-param name="inputValue">
                                                    <xsl:value-of select="normalize-space($AttributeSpecification)"/>
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </b>
                                        <br />
                                    </xsl:when>
                                </xsl:choose>
                                
				<xsl:variable name="AttributeTooltip">
					<xsl:value-of select="substring-after(normalize-space(@tooltip),normalize-space($AttributeSpecification))"/>
				</xsl:variable>
                                <!-- attribute tooltip: quadruple diagnostics
                                <xsl:if test="(@name='cycleInterval')">
                                    <xsl:message>
                                        <xsl:value-of select="../@name"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="@name"/>
                                        <xsl:text> $tooltip=</xsl:text>
                                        <xsl:value-of select="normalize-space(@tooltip)"/>
                                    </xsl:message>
                                    <xsl:message>
                                        <xsl:text>normalize-space($AttributeSpecification)=</xsl:text>
                                        <xsl:value-of select="normalize-space($AttributeSpecification)"/>
                                    </xsl:message>
                                    <xsl:message>
                                        <xsl:text>normalize-space($AttributeTooltip)=</xsl:text>
                                        <xsl:value-of select="normalize-space($AttributeTooltip)"/>
                                    </xsl:message>
                                    <xsl:message>
                                        <xsl:text>================================</xsl:text>
                                    </xsl:message>
                                </xsl:if>
                                -->
								
                                <!-- recursive colorizing and bolding of Hint: and Warning: keywords -->
								<xsl:call-template name="highlight-HintsWarnings">
									<xsl:with-param name="inputValue">
										<xsl:call-template name="emphasize-code-literals">
											<xsl:with-param name="inputValue" select="$AttributeTooltip"/>
										</xsl:call-template>
									</xsl:with-param>
								</xsl:call-template>
								
								<!-- diagnostic
								<xsl:message>
									<xsl:call-template name="emphasize-code-literals">
										<xsl:with-param name="inputValue" select="$AttributeTooltip"/>
									</xsl:call-template>
								</xsl:message>
								-->
								
			</td>

			<xsl:apply-templates/>

		</tr>
		
	</xsl:template>

<xsl:template name="emphasize-code-literals">
        <xsl:param name="inputValue"><xsl:text><!-- default value is empty --></xsl:text></xsl:param>
        <xsl:variable name="inputString" select="string($inputValue)"/>
        <xsl:analyze-string select="$inputString" regex='(ecmascript:)|(javascript:)|(vrmlscript:)'>
            <xsl:matching-substring>
                <!-- diagnostic
                <xsl:if test="contains($inputString,'script:')">
                    <xsl:message>
                        <xsl:text>*regex match success: </xsl:text>
						<code>
							<xsl:value-of select="."/>
						</code>
                    </xsl:message>
                </xsl:if>
                -->
                <code>
					<xsl:value-of select="."/>
                </code>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:copy-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
</xsl:template>

<xsl:template name="highlight-HintsWarnings"> <!-- &#38; is &amp; -->
        <xsl:param name="inputValue"><xsl:text><!-- default value is empty --></xsl:text></xsl:param>
        <xsl:variable name="inputString" select="string($inputValue)"/>
  <!--	
       <xsl:text>found... </xsl:text>
        <xsl:text>//###amp###&#10;</xsl:text>
	<xsl:text>### inputString received: </xsl:text>
	<xsl:value-of select="$inputString"/>
	<xsl:text>&#10;</xsl:text> 
  -->
  <xsl:choose>
    <!-- default baseline for all entries is X3D 3.0 -->
    <!-- [X3D 3.1] prefix -->
    <xsl:when test="starts-with(normalize-space($inputString),'(X3D version 3.1 or later)')">
      <font color="black"><xsl:text>(X3D version 3.1 or later) </xsl:text></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'(X3D version 3.1 or later)')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- [X3D 3.2] prefix -->
    <xsl:when test="starts-with(normalize-space($inputString),'(X3D version 3.2 or later)')">
      <font color="black"><xsl:text>(X3D version 3.2 or later) </xsl:text></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'(X3D version 3.2 or later)')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- [X3D 3.3] prefix -->
    <xsl:when test="starts-with(normalize-space($inputString),'(X3D version 3.3 or later)')">
      <font color="black"><xsl:text>(X3D version 3.3 or later) </xsl:text></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'(X3D version 3.3 or later)')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- [X3D 4.0] prefix -->
    <xsl:when test="starts-with(normalize-space($inputString),'(X3D version 4.0 draft)')">
      <!-- font color="black"><xsl:text>(X3D version 4.0 draft) </xsl:text></font -->
	  <xsl:text> (</xsl:text>
        <a href="https://www.web3d.org/x3d4" target="_blank">X3D version 4.0 draft</a>
	  <xsl:text>) </xsl:text>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'(X3D version 4.0 draft)')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- [X3D 4.0] embedded -->
    <xsl:when test="contains($inputString,'Hint: (X3D version 4.0 draft)') and not(starts-with(normalize-space($inputString),'(X3D version 4.0 draft)'))">
      <!-- debug diagnostic 
      <xsl:message>
         <xsl:text>diagnostic: found [X3D 4.0] embedded</xsl:text>
      </xsl:message> -->
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-before($inputString,'Hint: (X3D version 4.0 draft)')"/>
      </xsl:call-template>
      <br />
      <span style="background-color:{$cellColorX3Dv4}">
	    <xsl:text>Hint: (</xsl:text>
        <a href="https://www.web3d.org/x3d4" target="_blank">X3D version 4.0 draft</a>
	    <xsl:text>)</xsl:text>
      </span>
      <xsl:text> </xsl:text>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Hint: (X3D version 4.0 draft)')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="starts-with(normalize-space($inputString),'[X3D statement]')">
      <font color="black"><xsl:text>[X3D statement] </xsl:text></font>
      <br />
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'[X3D statement]')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- [X3DNodeType,X3DObject] node types and interfaces -->
    <xsl:when test="starts-with(normalize-space($inputString),'[X3D')">
        <font color="black"><xsl:text>[inherits </xsl:text></font>
        <xsl:variable name="nodeInheritance">
            <xsl:value-of select="normalize-space(translate(substring-before(substring-after($inputString,'['),']'),',',' '))"/>
        </xsl:variable>     
        <xsl:for-each select="tokenize($nodeInheritance,' ')"><!-- separator is blank charachter -->
            <xsl:call-template name="link-nodeType-constraint">
                <xsl:with-param name="nodeTypeConstraint">
                    <xsl:value-of select="."/>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:choose>
                <xsl:when test="(position() = 1) and not(position() = last())"><!-- position() is zero-based index, this is second entry in array-->
                    <font color="black"><xsl:text>, implements </xsl:text></font>
                </xsl:when>
                <xsl:when test="not(position() = last())">
                    <font color="black"><xsl:text>, </xsl:text></font>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
      <font color="black"><xsl:text>] </xsl:text></font>
      <br />
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,']')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Interchange profile hint English -->
    <xsl:when test="contains($inputString,'Interchange profile hint:')    
                    and not(contains(substring-before($inputString,'Interchange profile hint:'),   'Hint:'))   
                    and not(contains(substring-before($inputString,'Interchange profile hint:'),   'Warning:'))
                    and not(contains(substring-before($inputString,'Interchange profile hint:'),   'Example:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Interchange profile hint:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <xsl:if test="string-length(normalize-space(substring-before($inputString,'Interchange profile hint:'))) > 0">
          <br />
      </xsl:if>
      <font color="#553377"><b><xsl:text>Interchange profile hint:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Interchange profile hint:')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="contains($inputString,'Hint for VRML97:')    and not(contains(substring-before($inputString,'Hint:'),   'Warning:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Hint for VRML97:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Hint for VRML97:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Hint for VRML97:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Examples: English -->
    <xsl:when test="contains($inputString,'Example:')    and not(contains(substring-before($inputString,'Example:'),   'Examples:')) and not(contains(substring-before($inputString,'Example:'),   'Hint:')) and not(contains(substring-before($inputString,'Example:'),   'Warning:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Example:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Example:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Example:')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="contains($inputString,'Examples:')    and not(contains(substring-before($inputString,'Examples:'),   'Example:')) and not(contains(substring-before($inputString,'Examples:'),   'Hint:')) and not(contains(substring-before($inputString,'Examples:'),   'Warning:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Examples:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Examples:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Examples:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Hint: English -->
    <xsl:when test="contains($inputString,'Hint:')    and not(contains(substring-before($inputString,'Hint:'),   'Warning:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Hint:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Hint:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Hint:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Interchange profile hint Italian -->
    <xsl:when test="contains($inputString,'Suggerimento per il profilo Interchange:')    and not(contains(substring-before($inputString,'Interchange profile hint:'),   'Attenzione:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Suggerimento per il profilo Interchange:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#553377"><b><xsl:text>Suggerimento per il profilo Interchange:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Suggerimento per il profilo Interchange:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- hint Italian -->
    <xsl:when test="contains($inputString,'Suggerimento:')    and not(contains(substring-before($inputString,'Suggerimento:'),   'Attenzione:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Suggerimento:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Suggerimento:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Suggerimento:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- TODO m17 add here for Chinese-->
    <!-- Interchange profile hint Chinese -->
    <xsl:when test="contains($inputString,'概貌互换提示:')
        and (not(contains(substring-before($inputString,'概貌互换提示:'),   '警告:'))  and not(contains(substring-before($inputString,'概貌互换提示:'),   '提示:')))
        ">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'概貌互换提示:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#553377"><b><xsl:text>概貌互换提示:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'概貌互换提示:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- TODO m17 add here for Chinese-->
    <!-- hint Chinese -->
    <xsl:when test="contains($inputString,'提示:')    and not(contains(substring-before($inputString,'提示:'),   '警告:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'提示:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>提示:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'提示:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- hint French -->
    <xsl:when test="contains($inputString,'Conseil:') and not(contains(substring-before($inputString,'Conseil:'),'Attention:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Conseil:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Conseil:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Conseil:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- hint German -->
    <xsl:when test="contains($inputString,'Hinweis:') and not(contains(substring-before($inputString,'Nota:'),'Warnung:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Hinweis:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Hinweis:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Hinweis:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- hint Portuguese -->
    <xsl:when test="contains($inputString,'Dica:') and not(contains(substring-before($inputString,'Dica:'),'Aten&#231;&#227;o:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Dica:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Dica:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Dica:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- hint Spanish -->
    <xsl:when test="contains($inputString,'Nota:') and not(contains(substring-before($inputString,'Nota:'),'Advertencia:'))">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Nota:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#447777"><b><xsl:text>Nota:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Nota:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Warning English -->
    <xsl:when test="contains($inputString,'Warning:')">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Warning:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#ee5500"><b><xsl:text>Warning:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Warning:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Warning Italian -->
    <xsl:when test="contains($inputString,'Attenzione:')">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Attenzione:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#ee5500"><b><xsl:text>Attenzione:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Attenzione:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- TODO m17 add here for Chinese-->
    <!-- Warning Chinese -->
    <xsl:when test="contains($inputString,'警告:')">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'警告:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#ee5500"><b><xsl:text>警告:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'警告:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Warning French -->
    <xsl:when test="contains($inputString,'Attention:')">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Attention:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#ee5500"><b><xsl:text>Attention:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Attention:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Warning German -->
    <xsl:when test="contains($inputString,'Warnung:')">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Warnung:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#ee5500"><b><xsl:text>Warnung:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Warnung:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Warning Portuguese -->
    <xsl:when test="contains($inputString,'Aten&#231;&#227;o:')">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Aten&#231;&#227;o:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#ee5500"><b><xsl:text>Aten&#231;&#227;o:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Aten&#231;&#227;o:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Warning Spanish -->
    <xsl:when test="contains($inputString,'Advertencia:')">
      <xsl:call-template name="hyperlink">
          <xsl:with-param name="string">
              <xsl:copy-of select="substring-before($inputString,'Advertencia:')"/>
          </xsl:with-param>
      </xsl:call-template>
      <br />
      <font color="#ee5500"><b><xsl:text>Advertencia:</xsl:text></b></font>
      <xsl:call-template name="highlight-HintsWarnings">
        <xsl:with-param name="inputValue" select="substring-after($inputString,'Advertencia:')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- no more prefixes to highlight -->
    <xsl:otherwise>
        <!-- create hyperlinks out of urls -->
        <xsl:call-template name="hyperlink">
            <xsl:with-param name="string" select="$inputString"/>
        </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
    
<xsl:template name="range-interval-link">
        <xsl:param name="inputValue"><xsl:text><!-- default value is empty --></xsl:text></xsl:param>
        <xsl:variable name="inputString" select="string($inputValue)"/>
    <xsl:if test="contains(normalize-space($inputString),'] [') or contains(normalize-space($inputString),'] (')">
        <xsl:value-of select="substring-before($inputString,'] [')"/>
        <xsl:value-of select="substring-before($inputString,'] (')"/><!-- one or the other -->
        <xsl:text>] </xsl:text>
    </xsl:if>
    <xsl:variable name="rangeString">
        <xsl:choose>
            <xsl:when test="contains(normalize-space($inputString),'] [')">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="normalize-space(substring-after($inputString,'] ['))"/>
            </xsl:when>
            <xsl:when test="contains(normalize-space($inputString),'] (')">
                <xsl:text>(</xsl:text>
                <xsl:value-of select="normalize-space(substring-after($inputString,'] ('))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$inputString"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:choose>
        <xsl:when test="not(contains(normalize-space($inputString),'] [')) and not(contains(normalize-space($inputString),'] ('))">
            <!-- no range interval found so no link -->
            <xsl:value-of select="$inputString"/>
        </xsl:when> 
        <xsl:when test="ends-with(normalize-space($rangeString),']')"><!-- range interval -->
                <xsl:element name="a">
                        <xsl:attribute name="href">
                                <xsl:text>#RangeIntervals</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="title">
                            <xsl:text>Range interval</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(substring-before($rangeString,']'))"/>
                        <xsl:text>]</xsl:text>
                </xsl:element>
        </xsl:when>
        <xsl:when test="ends-with(normalize-space($rangeString),')')"><!-- range interval -->
                <xsl:element name="a">
                        <xsl:attribute name="href">
                                <xsl:text>#RangeIntervals</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="title">
                            <xsl:text>Range interval</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(substring-before($rangeString,')'))"/>
                        <xsl:text>)</xsl:text>
                </xsl:element>
        </xsl:when>
        <xsl:otherwise>
            <!-- no range interval found so no link -->
            <xsl:if test="not(starts-with(normalize-space($inputString),']'))">
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="$inputString"/>
        </xsl:otherwise>
    </xsl:choose>                             
</xsl:template>
    
<xsl:template name="xml-attribute-reference-bookmarks">
        <xsl:param name="inputValue"><xsl:text><!-- default value is empty --></xsl:text></xsl:param>
        <xsl:variable name="inputString" select="string($inputValue)"/>
    <xsl:choose>
        <xsl:when test="contains($inputString,'CDATA #FIXED')">
            <xsl:value-of select="substring-before(inputString,'CDATA #FIXED')"/>
            <xsl:element name="a">
                    <xsl:attribute name="href">
                            <xsl:text>#CDATA</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                            <xsl:text>CDATA means Character Data plain text (DTD validation)</xsl:text>
                    </xsl:attribute>
                    <xsl:text>CDATA</xsl:text>
            </xsl:element>
            <xsl:text> </xsl:text>
            <xsl:element name="a">
                    <xsl:attribute name="href">
                            <xsl:text>#FIXED</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                            <xsl:text>Required (fixed) value</xsl:text>
                    </xsl:attribute>
                    <xsl:text>#FIXED</xsl:text>
            </xsl:element>
            <xsl:call-template name="range-interval-link">
                <xsl:with-param name="inputValue">
                    <xsl:value-of select="substring-after($inputString,'#FIXED')"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($inputString,'CDATA #IMPLIED')">
            <xsl:value-of select="substring-before(inputString,'CDATA #IMPLIED')"/>
            <xsl:element name="a">
                    <xsl:attribute name="href">
                            <xsl:text>#CDATA</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                            <xsl:text>CDATA means Character Data plain text (DTD validation)</xsl:text>
                    </xsl:attribute>
                    <xsl:text>CDATA</xsl:text>
            </xsl:element>
            <xsl:text> </xsl:text>
            <xsl:element name="a">
                    <xsl:attribute name="href">
                            <xsl:text>#IMPLIED</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                            <xsl:text>#IMPLIED means that no default value is defined for this attribute</xsl:text>
                    </xsl:attribute>
                    <xsl:text>#IMPLIED</xsl:text>
            </xsl:element>
            <xsl:call-template name="range-interval-link">
                <xsl:with-param name="inputValue">
                    <xsl:value-of select="substring-after($inputString,'#IMPLIED')"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($inputString,'#REQUIRED')">
            <xsl:value-of select="substring-before(inputString,'#REQUIRED')"/>
            <xsl:element name="a">
                    <xsl:attribute name="href">
                            <xsl:text>#REQUIRED</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                            <xsl:text>#REQUIRED that an attribute value MUST always be provided</xsl:text>
                    </xsl:attribute>
                    <xsl:text>#REQUIRED</xsl:text>
            </xsl:element>
            <xsl:call-template name="range-interval-link">
                <xsl:with-param name="inputValue">
                    <xsl:value-of select="substring-after($inputString,'#REQUIRED')"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($inputString,'CDATA')">
            <xsl:value-of select="substring-before(inputString,'CDATA')"/>
            <xsl:element name="a">
                    <xsl:attribute name="href">
                            <xsl:text>#CDATA</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                            <xsl:text>CDATA means Character Data plain text (DTD validation)</xsl:text>
                    </xsl:attribute>
                    <xsl:text>CDATA</xsl:text>
            </xsl:element>
            <xsl:if test="not(starts-with(substring-after($inputString,'CDATA'),']'))">
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:call-template name="range-interval-link">
                <xsl:with-param name="inputValue">
                    <xsl:value-of select="substring-after($inputString,'CDATA')"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($inputString,'#FIXED')">
            <xsl:value-of select="substring-before(inputString,'#FIXED')"/>
            <xsl:element name="a">
                    <xsl:attribute name="href">
                            <xsl:text>#FIXED</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                            <xsl:text>Required (fixed) value</xsl:text>
                    </xsl:attribute>
                    <xsl:text>#FIXED</xsl:text>
            </xsl:element>
            <xsl:call-template name="range-interval-link">
                <xsl:with-param name="inputValue">
                    <xsl:value-of select="substring-after($inputString,'#FIXED')"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($inputString,'#IMPLIED')">
            <xsl:value-of select="substring-before(inputString,'#IMPLIED')"/>
            <xsl:element name="a">
                    <xsl:attribute name="href">
                            <xsl:text>#IMPLIED</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                            <xsl:text>#IMPLIED means that no default value is defined for this attribute</xsl:text>
                    </xsl:attribute>
                    <xsl:text>#IMPLIED</xsl:text>
            </xsl:element>
            <xsl:call-template name="range-interval-link">
                <xsl:with-param name="inputValue">
                    <xsl:value-of select="substring-after($inputString,'#IMPLIED')"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($inputString,'] [') and contains(substring-after($inputString,'] ['),']')">
            <!-- TODO still a problem with RigidBodyCollection set_contacts -->
            <xsl:variable name="nodeTypeConstraint">
                <xsl:value-of select="substring-before(substring-after($inputString,'] ['),']')"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="contains($nodeTypeConstraint,' ')">
                    <!-- ignore -->
                    <xsl:value-of select="normalize-space($inputString)"/>
                </xsl:when>
                <xsl:when test="not(contains($nodeTypeConstraint,'|'))">
                    <!-- single node or node type -->
                    <xsl:value-of select="substring-before($inputString,$nodeTypeConstraint)"/>
                    <xsl:call-template name="link-nodeType-constraint">
                        <xsl:with-param name="nodeTypeConstraint">
                            <xsl:value-of select="$nodeTypeConstraint"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="substring-after($inputString,$nodeTypeConstraint)"/>
                </xsl:when>
                <xsl:when test="contains($nodeTypeConstraint,'|')">
                    <!-- tokenize and handle multiple allowed constraints -->
                    <xsl:value-of select="substring-before($inputString,$nodeTypeConstraint)"/>
                    <xsl:for-each select="tokenize($nodeTypeConstraint,'\|')"><!-- separator is | literal -->
                        <xsl:call-template name="link-nodeType-constraint">
                            <xsl:with-param name="nodeTypeConstraint">
                                <xsl:value-of select="."/>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> | </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:value-of select="substring-after($inputString,$nodeTypeConstraint)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($inputString)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="normalize-space($inputString)"/>
        </xsl:otherwise>
    </xsl:choose>                      
</xsl:template>
    
<xsl:template name="link-nodeType-constraint">
  <xsl:param name="nodeTypeConstraint"/>
                    <xsl:choose>
                        <xsl:when test="starts-with($nodeTypeConstraint,'X3D')">
                            <xsl:element name="a">
                                <xsl:attribute name="target">
                                        <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="title">
                                    <xsl:choose>
                                        <xsl:when test="ends-with($nodeTypeConstraint,'Object')">
                                            <xsl:text>X3D abstract interface</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>X3D abstract node type</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$x3dSpecificationUrlBase"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="$x3dSpecificationNodeIndex"/>
                                    <xsl:text>#</xsl:text>
                                    <xsl:value-of select="$nodeTypeConstraint"/>
                                </xsl:attribute>
                                <xsl:value-of select="$nodeTypeConstraint"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="a">
                                <xsl:attribute name="title">
                                        <xsl:text>X3D concrete node</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:text>#</xsl:text>
                                    <xsl:value-of select="$nodeTypeConstraint"/>
                                </xsl:attribute>
                                <xsl:value-of select="$nodeTypeConstraint"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
</xsl:template>
    
	<!-- also used in CreateX3dSceneAccessInterfaceJava.xslt -->
    <xsl:template name="hyperlink">
        <!-- Search and replace urls in text:  adapted (with thanks) from 
            http://www.dpawson.co.uk/xsl/rev2/regex2.html#d15961e67 by Jeni Tennison using url regex (http://[^ ]+) -->
        <!-- Justin Saunders https://regexlib.com/REDetails.aspx?regexp_id=37 url regex ((mailto:|(news|(ht|f)tp(s?))://){1}\S+) -->
        <xsl:param name="string" select="string(.)"/>
        <!-- wrap html text string with spaces to ensure no mismatches occur -->
        <xsl:variable name="spacedString">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$string"/>
            <xsl:text> </xsl:text>
        </xsl:variable>
        <!-- diagnostic 
        <xsl:if test="contains($spacedString,'http')">
            <xsl:message>
                <xsl:text>diagnostic: $spacedString=</xsl:text>
                <xsl:value-of select="normalize-space($spacedString)"/>
            </xsl:message>
        </xsl:if>
        -->
        <!-- First: find and link url values.  Avoid matching encompassing quote marks. -->
        <xsl:analyze-string select="$spacedString" regex='(mailto:|((news|http|https|sftp)://)[a-zA-Z0-9._%+-/#()]+)'>
            <xsl:matching-substring>
                <!-- diagnostic
                <xsl:if test="contains($spacedString,'url1')">
                    <xsl:message>
                        <xsl:text>*regex match success:</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:message>
                </xsl:if>
                -->
                <xsl:element name="font">
                    <xsl:attribute name="size">
                        <xsl:text>-1</xsl:text>
                    </xsl:attribute>
					<xsl:element name="a">
						<xsl:attribute name="target">
							<xsl:text>_blank</xsl:text>
						</xsl:attribute>
						<!--
						<xsl:attribute name="class">
							<xsl:text>font-size: smaller;</xsl:text>
						</xsl:attribute>
						-->
						<xsl:attribute name="href">
							<xsl:value-of select="."/>
							<xsl:if test="(contains(.,'youtube.com') or contains(.,'youtu.be')) and not(contains(.,'rel='))">
								<!-- prevent advertising other YouTube videos when complete -->
								<xsl:text disable-output-escaping="yes">&amp;rel=0</xsl:text>
							</xsl:if>
						</xsl:attribute>
						<xsl:copy-of select="."/>
					</xsl:element>
				</xsl:element>
            <!-- <xsl:text> </xsl:text> -->
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <!-- diagnostic
                <xsl:if test="contains($spacedString,'url1')">
                    <xsl:message>
                        <xsl:text>**regex match failure:</xsl:text>
                        <xsl:copy-of select="."/>
                    </xsl:message>
                </xsl:if>
                -->
                <!-- avoid returning excess whitespace -->
                <xsl:choose>
                    <xsl:when test="(string-length(.) > 0) and (string-length(normalize-space(.)) = 0)">
                        <xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space(.)) > 0">
                        <xsl:copy-of select="." />
                    </xsl:when>
                </xsl:choose>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

</xsl:stylesheet>

