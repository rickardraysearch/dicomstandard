<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                version='1.0'>
				
	<xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/fo/docbook.xsl"/>
	
	<xsl:import href="customizedtitlepages-fo-pdf-releasenotes.xsl"/>	<!-- http://www.sagehill.net/docbookxsl/TitlePageGraphics.html -->

	<xsl:import href="customize-common.xsl"/>

	<xsl:param name="default.table.rules" select="'all'"/>

	<!-- specify default body font and size -->
	<!-- <xsl:param name="body.font.family" select="'sans-serif,KozMinProVI-Regular'"/> -->		<!-- http://www.simon-cozens.org/content/docbook-fop-fonts-and-multilingua -->
	<xsl:param name="body.font.family" select="'sans-serif'"/>
	<xsl:param name="body.font.master" select="9"/>
	
	<xsl:param name="body.start.indent" select="'0pt'"/>		<!-- Turn off indenting; see http://www.sagehill.net/docbookxsl/PrintOutput.html#IndentingBodyText -->
	<xsl:param name="page.margin.inner">0.75in</xsl:param>
	<xsl:param name="page.margin.outer">0.50in</xsl:param>
	
	<xsl:param name="header.column.widths">1 8 1</xsl:param>

	<xsl:param name="draft.mode" select="'no'"/>
	<!-- <xsl:param name="draft.watermark.image" select="'http://docbook.sourceforge.net/release/xsl-ns/current/images/draft.png'"/> -->	<!-- should use rewrite rule in catalog.xml to find it -->
	<xsl:param name="draft.watermark.image" select="'file:///Users/dclunie/Documents/Work/DICOM_Publish_XML/DocBookDICOM2013/docbook-xsl-ns-1.78.1/images/draft.png'"/>	<!-- rewrite rule never seems to get invoked so hard wire it -->
	
	<xsl:param name="xref.with.number.and.title" select="'1'"/>
	<xsl:param name="glossentry.show.acronym" select="'yes'"/>
	<xsl:param name="index.on.role" select="'1'"/>			<!-- use old role rather than type terminology in case 4.2 or earlier DTD encountered - see note in DocBook XSL Ch 18 Indexes - Specialized Indexes -->

	<!-- <xsl:param name="insert.xref.page.number" select="'maybe'"/> --> <!-- do not need these since default is to follow xrefstyle in document-->
	<!-- <xsl:param name="insert.link.page.number" select="'maybe'"/> -->
	<!-- <xsl:param name="insert.olink.page.number" select="'maybe'"/> -->
	
	<xsl:param name="ulink.show" select="'0'"/>	<!-- Even though DocBook 5 has no ulink element, this parameter is still used to control URL after link to href ... need to supress this e.g., for LN outlinks in part 16 -->

	<xsl:param name="olink.doctitle" select="'maybe'"/>
	<xsl:param name="insert.olink.pdf.frag" select="'1'"/>

	<xsl:param name="xref.label-title.separator" select="' '"/>		<!-- rather than default ': '; see "http://www.sagehill.net/docbookxsl/CustomXrefs.html" -->

	<!-- footnotes in tables are numbered -->
	<xsl:param name="table.footnote.number.format" select="'1'"/>
	
	<xsl:param name="runinhead.default.title.end.punct" select="''"/>	<!-- do  NOT use default period after formalpara titles -->

	<!-- section depth in TOC -->
	<xsl:param name="toc.section.depth" select="7"/>
	<xsl:param name="toc.indent.width">12</xsl:param>	<!-- reduced from initial value of 24, because a lot of long titles cause wrapping -->
	<xsl:param name="formal.title.placement">
	figure after
	</xsl:param>

	<!-- <xsl:param name="xep.extensions" select="1"/> -->
	<!-- <xsl:param name="fop.extensions" select="'1'"/> -->
	<!-- <xsl:param name="fop1.extensions" select="1"/> --> <!--  Enable extensions for FOP version 0.90 and later ; includes bookmarks -->

	<xsl:param name="use.svg" select="1"/>

	<xsl:param name="generate.toc">
	appendix	nop
	article		nop
	book		nop
	chapter		nop
	part		nop
	preface		nop
	qandadiv	nop
	qandaset	nop
	reference	nop
	section		nop
	set			nop
	</xsl:param>

	<xsl:param name="default.table.width" select="'100%'"/>
	
	<xsl:param name="orderedlist.label.width">2em</xsl:param>

	<!-- URLs in PS 3.16 Annex D tables were causing page width overflow, so activate URL "hyphenation"; see "http://www.sagehill.net/docbookxsl/Ulinks.html" -->
	<xsl:param name="ulink.hyphenate.chars">/&amp;?</xsl:param>
	<xsl:param name="ulink.hyphenate">&#x200B;</xsl:param>
	
	<!-- title font size -->
	<xsl:attribute-set name="book.titlepage.recto.style">
		<xsl:attribute name="font-size">14pt</xsl:attribute>
	</xsl:attribute-set>
	<!-- each section starts on a new page -->
	<xsl:attribute-set name="section.title.level1.properties">
		<!-- <xsl:attribute name="break-before">page</xsl:attribute> -->
		<xsl:attribute name="font-size">14pt</xsl:attribute>
	</xsl:attribute-set>
	<!-- 2nd level section font size -->
	<xsl:attribute-set name="section.title.level2.properties">
		<xsl:attribute name="font-size">12pt</xsl:attribute>
	</xsl:attribute-set>
	<!-- admonition style -->
	<xsl:attribute-set name="admonition.title.properties">
		<xsl:attribute name="font-size">9pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="informalfigure.properties">
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="figure.properties">
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set>

	<!-- turn off hyphenation in table and variablelist to prevent hyphenation of defined terms and enumerated values ... -->
	<!-- see "http://www.sagehill.net/docbookxsl/PrintCustomEx.html#Hyphenation" and "http://docbook.sourceforge.net/release/xsl/current/doc/fo/variablelist.term.properties.html" -->
	<xsl:attribute-set name="table.table.properties">
		<xsl:attribute name="hyphenate">false</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="variablelist.term.properties">
		<xsl:attribute name="hyphenate">false</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="glossentry.list.item.properties">
		<xsl:attribute name="hyphenate">false</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="example.properties">
		<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
		<xsl:attribute name="padding">0.1in</xsl:attribute>
	</xsl:attribute-set>

	<!-- Number pages from 1 - see "https://www.sourceware.org/ml/docbook-apps/2004-q4/msg00148.html"-->
	<!-- This template always returns the string '1', which sets the page number format to 1,2,3,... -->
	<xsl:template name="page.number.format">
		<xsl:param name="element" select="local-name(.)"/>
		<xsl:param name="master-reference" select="''"/>
		<xsl:value-of select="'1'"/>
	</xsl:template>

	<!-- This template always continues the page numbering. -->
	<!-- For double-sided output, it also forces chapters to start on odd-numbered pages -->
	<xsl:template name="initial.page.number">
		<xsl:param name="element" select="local-name(.)"/>
		<xsl:param name="master-reference" select="''"/>
		<xsl:choose>
			<!-- double-sided output -->
			<xsl:when test="$double.sided != 0">auto-odd</xsl:when>
			<xsl:otherwise>auto</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- Want to center table titles (captions) in PDF output; see "https://lists.oasis-open.org/archives/docbook-apps/200403/msg00129.html" -->
<!-- and do not forget to include namespace "d:" when matching ! -->

<xsl:template name="formal.object.heading">
  <xsl:param name="object" select="."/>
  <xsl:param name="placement" select="'before'"/>

  <fo:block xsl:use-attribute-sets="formal.title.properties">
    <xsl:if test="self::d:table">
      <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$placement = 'before'">
        <xsl:attribute
               name="keep-with-next.within-column">always</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute
               name="keep-with-previous.within-column">always</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="$object" mode="object.title.markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<!-- customize page header to include part not section; see "http://www.sagehill.net/docbookxsl/PrintHeaders.html"; edit template from "fo/pagesetup.xsl"-->

<xsl:template name="header.content">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="position" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

  <fo:block>

    <!-- sequence can be odd, even, first, blank -->
    <!-- position can be left, center, right -->
    <xsl:choose>

	  <!-- rather than using gentext, just assume english -->
      <xsl:when test="$position='right'">
		<xsl:text>Page </xsl:text><fo:page-number/>
      </xsl:when>

      <xsl:when test="$position='center'">
		  <xsl:value-of select="/d:book/d:title"/><xsl:text> - </xsl:text><xsl:value-of select="/d:book/d:subtitle"/>
      </xsl:when>

    </xsl:choose>
  </fo:block>
</xsl:template>

<xsl:template name="footer.content">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="position" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

  <fo:block>
    <!-- pageclass can be front, body, back -->
    <!-- sequence can be odd, even, first, blank -->
    <!-- position can be left, center, right -->
    <xsl:choose>
      <xsl:when test="$position='center'">
        <!-- Same for odd, even, empty, and blank sequences -->
		<xsl:choose>
			<!-- rather than calling template name="draft.text", use a simplified version that is sufficient for our purposes -->
			<!-- rather than using gentext and extending common/en.xml (etc.) to include these words, just assume english -->
			<xsl:when test="$draft.mode = 'yes'">
				<xsl:text>- Draft -</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>- Standard -</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
      </xsl:when>

    </xsl:choose>
  </fo:block>
</xsl:template>

<!-- provide access to label attribute of glossdiv and bibliodiv (similar to mechanism in common/labels.xsl) -->

<xsl:template match="d:glossdiv|d:bibliodiv" mode="label.markup">
      <xsl:value-of select="@label"/>
</xsl:template>

<!-- create a glossdiv and bibliodiv specific template to override the default in common/gentext.xsl that does not number these ever -->
<xsl:template match="d:glossdiv|d:bibliodiv"
              mode="object.title.template">

      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-numbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    
</xsl:template>

<!-- Do not italicize docname in olink -->
<xsl:template match="*" mode="insert.olink.docname.markup">
  <xsl:param name="docname" select="''"/>
  
  <fo:inline>
    <xsl:value-of select="$docname"/>
  </fo:inline>

</xsl:template>

<!-- do not allow cells in tables to break across pages -->
<!-- copied from fo/table.xsl and customized ... see "http://www.sagehill.net/docbookxsl/PrintTableStyles.html#table.table.properties" and "http://www.sagehill.net/docbookxsl/PageBreaking.html" -->
<!-- also limits on this with rowspan - see "http://lists.renderx.com/pipermail/xep-support/2003-January/000966.html" -->

<xsl:template name="table.cell.block.properties">
<xsl:attribute name="keep-together.within-column">always</xsl:attribute>	<!-- DAC. added this -->
  <xsl:choose>
    <xsl:when test="ancestor::d:thead or ancestor::d:tfoot">
      <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:when>
    <!-- Make row headers bold too -->
    <xsl:when test="ancestor::d:tbody and 
                    (ancestor::d:table[@rowheader = 'firstcol'] or
                    ancestor::d:informaltable[@rowheader = 'firstcol']) and
                    ancestor-or-self::d:entry[1][count(preceding-sibling::d:entry) = 0]">
      <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- do not want title pages for book at all -->

<xsl:template name="book.titlepage.recto"/>
<xsl:template name="book.titlepage.verso"/>

<!-- DAC. This template from fo/xep.xsl needs to be patched so as not to include both label and title in pdf title metainformation-->

<xsl:template name="xep-document-information">
  <rx:meta-info>
    <xsl:variable name="authors" 
                  select="(//d:author|//d:editor|//d:corpauthor|//d:authorgroup)[1]"/>
    <xsl:if test="$authors">
      <xsl:variable name="author">
        <xsl:choose>
          <xsl:when test="$authors[self::d:authorgroup]">
            <xsl:call-template name="person.name.list">
              <xsl:with-param name="person.list" 
                        select="$authors/*[self::d:author|self::d:corpauthor|
                               self::d:othercredit|self::d:editor]"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$authors[self::d:corpauthor]">
            <xsl:value-of select="$authors"/>
          </xsl:when>
          <xsl:when test="$authors[d:orgname]">
            <xsl:value-of select="$authors/d:orgname"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="person.name">
              <xsl:with-param name="node" select="$authors"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:element name="rx:meta-field">
        <xsl:attribute name="name">author</xsl:attribute>
        <xsl:attribute name="value">
          <xsl:value-of select="normalize-space($author)"/>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>

    <xsl:variable name="title">
      <!--<xsl:apply-templates select="/*[1]" mode="label.markup"/>-->	<!-- DAC. e.g., do not want "PS3.3PS3.3" -->
      <xsl:apply-templates select="/*[1]" mode="title.markup"/>
    </xsl:variable>

    <xsl:element name="rx:meta-field">
      <xsl:attribute name="name">creator</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:text>DocBook </xsl:text>
        <xsl:value-of select="$DistroTitle"/>
        <xsl:text> V</xsl:text>
        <xsl:value-of select="$VERSION"/>
      </xsl:attribute>
    </xsl:element>

    <xsl:element name="rx:meta-field">
      <xsl:attribute name="name">title</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="normalize-space($title)"/>
      </xsl:attribute>
    </xsl:element>

    <xsl:if test="//d:keyword">
      <xsl:element name="rx:meta-field">
        <xsl:attribute name="name">keywords</xsl:attribute>
        <xsl:attribute name="value">
          <xsl:for-each select="//d:keyword">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position() != last()">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>

    <xsl:if test="//d:subjectterm">
      <xsl:element name="rx:meta-field">
        <xsl:attribute name="name">subject</xsl:attribute>
        <xsl:attribute name="value">
          <xsl:for-each select="//d:subjectterm">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position() != last()">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>
  </rx:meta-info>
</xsl:template>

<!-- do not italicize foreignphrase -->
<xsl:template match="d:foreignphrase">
  <!--<xsl:call-template name="inline.italicseq"/>-->
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

</xsl:stylesheet>
