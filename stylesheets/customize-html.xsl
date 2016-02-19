<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook">
				
	<xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/xhtml/docbook.xsl"/>
	
	<xsl:import href="customizedtitlepages-xhtml.xsl"/>	<!-- http://www.sagehill.net/docbookxsl/TitlePageGraphics.html -->

	<xsl:import href="customize-common.xsl"/>
	
	<!-- specify default body font and size -->
	<xsl:param name="body.font.family" select="'sans-serif'"/>
	<xsl:param name="body.font.master" select="9"/>

	<xsl:param name="draft.mode" select="'no'"/>
	<xsl:param name="draft.watermark.image" select="'figures/draft.png'"/>	<!-- uses rewrite rule in catalog.xml to find it -->
	
	<xsl:param name="xref.with.number.and.title" select="'1'"/>
	<xsl:param name="glossentry.show.acronym" select="'yes'"/>
	<xsl:param name="index.on.role" select="'1'"/>			<!-- use old role rather than type terminology in case 4.2 or earlier DTD encountered - see note in DocBook XSL Ch 18 Indexes - Specialized Indexes -->

	<xsl:param name="olink.doctitle" select="'maybe'"/>

	<xsl:param name="xref.label-title.separator" select="' '"/>		<!-- rather than default ': '; see "http://www.sagehill.net/docbookxsl/CustomXrefs.html" -->

	<!-- footnotes in tables are numbered -->
	<xsl:param name="table.footnote.number.format" select="'1'"/>
	
	<xsl:param name="runinhead.default.title.end.punct" select="''"/>	<!-- do NOT use default period after formalpara titles -->

	<xsl:param name="make.clean.html" select="'0'"></xsl:param>		<!-- tried setting this to '1' to activate <span class="formalpara-title"/> around formalpara title without customizing xhtml/block.xsl, but messed up too many things :( -->

	<!-- section depth in TOC -->
	<xsl:param name="toc.section.depth" select="7"/>
	<xsl:param name="formal.title.placement">
	figure after
	</xsl:param>
	<!-- <xsl:param name="xep.extensions"  select="1"/> -->
	<!-- <xsl:param name="fop.extensions" select="'1'"/> -->
	<xsl:param name="use.svg" select="1"/>
	<xsl:param name="generate.toc">
	appendix	nop
	article		nop
	book		toc,title,figure,table,example
	chapter		nop
	part		nop
	preface		nop
	qandadiv	nop
	qandaset	nop
	reference	nop
	section		nop
	set			nop
	</xsl:param>
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

	<!-- Need to customize watermark image inclusion, since this doesn't work unless we copy it
	     here from xhtml/docbook.xsl (no idea why; didn't change it, but this prevents the pMML2SVG
		 adding suprious CDATA wrapper that prevents browser from using it) -->
	<!-- While we are customizing, might as well activate background repeat vertically (but not horizontally) and center -->
<xsl:template name="head.content.style">
  <xsl:param name="node" select="."/>
  <style type="text/css"><xsl:text>
body { background-image: url('</xsl:text>
<xsl:value-of select="$draft.watermark.image"/><xsl:text>');
       background-repeat: repeat-y;
       background-position: center;
       /* The following properties make the watermark "fixed" on the page. */
       /* I think that's just a bit too distracting for the reader... */
       /* background-attachment: fixed; */
       /* background-position: center center; */
     }</xsl:text>
    </style>
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

<!-- Unlike with FO, there is a specific template to match these that normally generates an h3 and nothing else; need to override these and make component.title in xhtml/component.xsl do the work using the gentext mechanism customized above -->
<xsl:template match="d:glossdiv/d:title|d:bibliodiv/d:title">
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="component.title">
		<xsl:with-param name="node" select=".."/>
	</xsl:call-template>
</xsl:template>

<!-- do not italicize foreignphrase -->
<xsl:template match="d:foreignphrase">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <!--<xsl:call-template name="inline.italicseq"/>-->
    <xsl:call-template name="inline.charseq"/>
  </span>
</xsl:template>

</xsl:stylesheet>
