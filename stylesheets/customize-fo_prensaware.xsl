<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                version='1.0'>
	<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/>

	<xsl:param name="default.table.rules" select="'all'"/> 

	<!-- specify default body font and size -->
	<!-- <xsl:param name="body.font.family" select="'sans-serif,KozMinProVI-Regular'"/> -->		<!-- http://www.simon-cozens.org/content/docbook-fop-fonts-and-multilingua -->
	<xsl:param name="body.font.family" select="'sans-serif'"/>
	<xsl:param name="body.font.master" select="9"/>
	<!-- no draft mode -->
	<!-- <xsl:param name="draft.mode" select="no"/> -->
	<xsl:param name="draft.watermark.image" select="''"/>
	<xsl:param name="xref.with.number.and.title" select="'1'"/>
	<xsl:param name="glossentry.show.acronym" select="'yes'"/>
	<xsl:param name="index.on.role" select="'1'"/>			<!-- use old role rather than type terminology in case 4.2 or earlier DTD encountered - see note in DocBook XSL Ch 18 Indexes - Specialized Indexes -->

	<!-- appendices are called annexes -->
	<xsl:param name="local.l10n.xml" select="document('')"/>
	<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
		<l:l10n language="en">
			<l:gentext key="hyphenation-character" text="-"/>
			<l:gentext key="chapter" text="Section"/>
			<l:gentext key="Chapter" text="Section"/>
			<l:gentext key="appendix" text="Annex"/>
			<l:gentext key="Appendix" text="Annex"/>

			<l:context name="title-numbered">
				<l:template name="chapter" text="%n&#160;%t"/>
				<l:template name="section" text="%n&#160;%t"/>
				<l:template name="appendix" text="Annex&#160;%n&#160;%t"/>
			</l:context>

			<!-- number unnumbered anyway -->
			<l:context name="title-unnumbered">
				<l:template name="chapter" text="%n&#160;%t"/>
				<l:template name="section" text="%n&#160;%t"/>
			</l:context>
			
			<l:context name="xref">
				<l:template name="chapter" text="Section&#160;%n, &#8220;%t&#8221;"/>
				<l:template name="appendix" text="Annex&#160;%n, &#8220;%t&#8221;"/>
				<l:template name="section" text="Section&#160;%n, &#8220;%t&#8221;"/>
			</l:context>
		</l:l10n>
	</l:i18n>

	<xsl:param name="xref.label-title.separator" select="' '"/>		<!-- rather than default ': '; see "http://www.sagehill.net/docbookxsl/CustomXrefs.html" -->

	<!-- footnotes in tables are numbered -->
	<xsl:param name="table.footnote.number.format" select="'1'"/>
	<!-- sections are numbered but using supplied label -->
	<xsl:param name="chapter.autolabel" select="'0'"/>
	<xsl:param name="section.autolabel" select="'0'"/>
	<xsl:param name="section.label.includes.component.label" select="'0'"/>
	<!-- section depth in TOC -->
	<xsl:param name="toc.section.depth" select="7"/>
	<xsl:param name="formal.title.placement">
	figure after
	</xsl:param>

	<xsl:param name="xep.extensions" select="1"/>
	<!-- <xsl:param name="fop.extensions" select="'1'"/> -->
	<!-- <xsl:param name="fop1.extensions" select="1"/> --> <!--  Enable extensions for FOP version 0.90 and later ; includes bookmarks -->

	<xsl:param name="use.svg" select="1"/>

	<xsl:param name="generate.toc">
	appendix	nop
	article		nop
	book		toc,title,figure,table
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

	<!-- This parameter should control PDF bookmarks initial state, and is supposed to in FOP, and is used in fop1.xsl; see "http://docbook.sourceforge.net/release/xsl/current/doc/fo/bookmarks.collapse.html" -->
	<xsl:param name="bookmarks.collapse" select="1"></xsl:param>

	<!-- Need to customize xep.xsl template to do the same as fop1.xsl wrt. bookmarks.collapse -->
	<!-- See also (obsolete) discussion at "https://lists.oasis-open.org/archives/docbook-apps/200903/msg00195.html" -->
	<!-- See also "https://lists.oasis-open.org/archives/docbook-apps/201309/msg00071.html" -->
	<!-- See also RenderX User Manual that discusses the "starting-state" attribute and its evolution -->
	<!-- Note that this customization means that the rx namespace needs to be defined in xsl:stylesheet -->
	
<xsl:variable name="bookmarks.state">
  <xsl:choose>
    <xsl:when test="$bookmarks.collapse != 0">hide</xsl:when>
    <xsl:otherwise>show</xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:template match="set|book|part|reference|preface|chapter|appendix|article
                     |glossary|bibliography|index|setindex|topic
                     |refentry|refsynopsisdiv
                     |refsect1|refsect2|refsect3|refsection
                     |sect1|sect2|sect3|sect4|sect5|section"
              mode="xep.outline">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="bookmark-label">
    <xsl:apply-templates select="." mode="object.title.markup"/>
  </xsl:variable>

  <!-- Put the root element bookmark at the same level as its children -->
  <!-- If the object is a set or book, generate a bookmark for the toc -->
  <xsl:choose>
    <xsl:when test="self::index and $generate.index = 0"/>	
    <xsl:when test="parent::*">
      <rx:bookmark internal-destination="{$id}">
	<xsl:attribute name="starting-state">
	  <xsl:value-of select="$bookmarks.state"/>
	</xsl:attribute>
        <rx:bookmark-label>
          <xsl:value-of select="normalize-space($bookmark-label)"/>
        </rx:bookmark-label>
        <xsl:apply-templates select="*" mode="xep.outline"/>
      </rx:bookmark>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$bookmark-label != ''">
        <rx:bookmark internal-destination="{$id}">
	<xsl:attribute name="starting-state">
	  <xsl:value-of select="$bookmarks.state"/>
	</xsl:attribute>
          <rx:bookmark-label>
            <xsl:value-of select="normalize-space($bookmark-label)"/>
          </rx:bookmark-label>
        </rx:bookmark>
      </xsl:if>

      <xsl:variable name="toc.params">
        <xsl:call-template name="find.path.params">
          <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="contains($toc.params, 'toc')
                    and set|book|part|reference|section|sect1|refentry
                        |article|topic|bibliography|glossary|chapter
                        |appendix">
        <rx:bookmark internal-destination="toc...{$id}">
          <rx:bookmark-label>
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="'TableofContents'"/>
            </xsl:call-template>
          </rx:bookmark-label>
        </rx:bookmark>
      </xsl:if>
      <xsl:apply-templates select="*" mode="xep.outline"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- do not italicize foreignphrase -->
<xsl:template match="d:foreignphrase">
  <!--<xsl:call-template name="inline.italicseq"/>-->
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

</xsl:stylesheet>
