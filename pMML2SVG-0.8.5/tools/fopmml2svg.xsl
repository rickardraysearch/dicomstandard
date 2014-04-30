<?xml version="1.0"?>
<!-- 
###############################################################################
$Id: pmml2svg.xsl 46 2009-03-09 15:54:24Z jjoslet $

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
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
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

  <!-- ALL ELEMENTS THAT ARE NOT MATHML: SIMPLY COPY AND GO ON -->
  <xsl:template match="*[namespace-uri()!='http://www.w3.org/1998/Math/MathML' and name()!='fo:instream-foreign-object']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>

  <!-- fo:instream-foreign-objects -->
  <xsl:template match="fo:instream-foreign-object">
    <xsl:choose>
      <xsl:when test="child::math:math">
	<xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates />
	</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ####################################################################
       ROOT ELEMENT
       #################################################################### -->
  <xsl:template match="math:math">
    <xsl:variable name="size" select="ancestor::*[@font-size][1]/@font-size"/>
    <xsl:variable name="sizeFromContext" select="number(replace($size, '[A-Za-z%]', ''))"/>
    <xsl:variable name="masterUnit" select="replace($size, '[0-9.]', '')"/>

    <!-- Is element embedded in text -->
    <xsl:variable name="embedded" select="string-length(normalize-space(string-join(parent::*/parent::*/text(), ''))) != 0"/>

    <xsl:variable name="svgOutput">
      <xsl:apply-imports>
	<xsl:with-param name="initSize" select="$sizeFromContext" tunnel="yes"/>
	<xsl:with-param name="svgMasterUnit" select="$masterUnit" tunnel="yes"/>
	<!-- Set display style from context -->
	<xsl:with-param name="displayStyle" select="if ($embedded) then 'false' else 'true'" tunnel="yes"/>
      </xsl:apply-imports>
    </xsl:variable>

    <!-- If element is embedded in text, set a baseline adjustement -->
    <xsl:variable name="adjust" select="if ($embedded)
					then concat('-', $svgOutput/svg:svg/svg:metadata/pmml2svg:baseline-shift/text(), $masterUnit)
					else 0"/>
    
    <fo:instream-foreign-object alignment-adjust="{$adjust}">
      <xsl:copy-of select="$svgOutput"/>
    </fo:instream-foreign-object>
  </xsl:template>

</xsl:stylesheet>
