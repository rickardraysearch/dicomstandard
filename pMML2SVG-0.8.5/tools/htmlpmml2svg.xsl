<?xml version="1.0"?>
<!-- 
###############################################################################
$Id: htmlpmml2svg.xsl,v 1.2 2015/07/01 19:29:19 dclunie Exp $

CREATED: MARCH 2009

AUTHORS: [AST] Alexandre Stevens (alex@dourfestival.be) {STUDENT}
         [JHP] Justus H. Piater (Justus.Piater@ULg.ac.be) {PhD}
         [TMO] Thibault Mouton (Thibault.Mouton@student.ULg.ac.be) {STUDENT}
	 [JJO] Jerome Joslet (Jerome.Joslet@student.ULg.ac.be) {STUDENT}
         Montefiore Institute - University of Liege - Belgium
         
         [STM] Manuel Strehl {STUDENT}
         University of Regensburg - Germany

DESCRIPTION: This stylesheet converts MathML contained in a xsl-fo file into SVG.


Copyright (C) 2009 by Joslet Jerome and Justus H. Piater.

This file is part of pMML2SVG.

pMML2SVG is free software; you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License as published by the
Free Software Foundation; either version 2, or (at your option) any
later version.

pMML2SVG is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License
for more details.

You should have received a copy of the GNU Lesser General Public License
along with pMML2SVG; see the file COPYING.  If not, write to the Free
Software Foundation, 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

###############################################################################
-->
<xsl:stylesheet version="2.0"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:math="http://www.w3.org/1998/Math/MathML"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:svg="http://www.w3.org/2000/svg"
		xmlns:t="http://localhost/tmp"
		xmlns:func="http://localhost/functions"
		xmlns:pmml2svg="https://sourceforge.net/projects/pmml2svg/"
		exclude-result-prefixes="math t xs func svg pmml2svg">
 
  <!-- Import pMML2SVG stylesheet -->
  <xsl:import href="../XSLT2/pmml2svg.xsl"/>

  <!-- Output for svg -->
  <xsl:output name="svg" method="xml" indent="yes" version="1.0"
	      omit-xml-declaration="no"
	      media-type="image/svg+xml"
	      doctype-public="-//W3C//DTD SVG 1.1//EN"
	      doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
	      cdata-section-elements="style"/>

  <xsl:output method="xml" indent="yes" version="1.0"
	      omit-xml-declaration="no"
	      media-type="application/xhtml+xml"
	      doctype-public="-//W3C//DTD XHTML 1.1//EN"
	      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	      cdata-section-elements="style"/>

  <xsl:template match="*[name() = 'head']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates />

      <style type="text/css">
	p { font-size: 15px; }
      </style>
    </xsl:copy>
  </xsl:template>

  <!-- ALL ELEMENTS THAT ARE NOT MATHML: SIMPLY COPY AND GO ON -->
  <xsl:template match="*[namespace-uri()!='http://www.w3.org/1998/Math/MathML' and name() != 'head']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>


  <!-- ####################################################################
       ROOT ELEMENT
       #################################################################### -->
  <xsl:template match="math:math">

    <xsl:variable name="position" select="count(preceding::*[name() = 'math' or name() = 'math:math']) + 1"/>

    <xsl:variable name="svgOutput">
      <xsl:apply-imports>
	<xsl:with-param name="initSize" select="15" tunnel="yes"/>
	<!-- Set display style from context -->
	<xsl:with-param name="displayStyle" select="if (parent::*[name() = 'div' and @class = 'equation-contents'])
					then 'true'
					else 'false'" 
			tunnel="yes"/>
      </xsl:apply-imports>
    </xsl:variable>

    <!-- Retrieve doc name -->
    <xsl:variable name="doc" select="tokenize(base-uri(), '/')"/>
    <xsl:variable name="docName" select="substring-before($doc[count($doc)], '.html')"/>

    <xsl:result-document format="svg" href="{$docName}_image_{$position}.svg">
      <xsl:copy-of select="$svgOutput"/>
    </xsl:result-document>

    <!-- If MathML is not embedded in a text, don't shift it -->
    <xsl:variable name="adjust" select="if (parent::*[name() = 'div' and @class = 'equation-contents'])
					then ''
					else concat('position: relative; bottom: -', 
					     $svgOutput/svg:svg/svg:metadata/pmml2svg:baseline-shift/text(), 
					     'px;')"/>

    <object type="image/svg+xml" data="{$docName}_image_{$position}.svg" 
	    style="{$adjust}">
      <param name="src" value="image_{$position}.svg"/>
    </object>

  </xsl:template>

</xsl:stylesheet>
