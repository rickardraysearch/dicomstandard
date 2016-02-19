<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                version='1.0'>

	<!-- chapters, appendices and sections all use label attribute of element (empty if no label) and not auto-numbering - affects the l:i18n "title-numbered" and "title-unnumbered" contexts -->
	<xsl:param name="chapter.autolabel" select="'0'"/>
	<xsl:param name="section.autolabel" select="'0'"/>
	<xsl:param name="appendix.autolabel" select="'0'"/>
	
	<xsl:param name="section.label.includes.component.label" select="'0'"/>

	<!-- appendices are called annexes -->
	<xsl:param name="local.l10n.xml" select="document('')"/>
	<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
		<l:l10n language="en">
			<l:gentext key="hyphenation-character" text="-"/>
			<l:gentext key="chapter" text="Section"/>
			<l:gentext key="Chapter" text="Section"/>
			<l:gentext key="appendix" text="Annex"/>
			<l:gentext key="Appendix" text="Annex"/>

			<!-- this is only actually used if we customize the object.title.template mode templates in common/gentext.xsl to check for label value as well as autonumber -->
			<l:context name="title-numbered">
				<l:template name="chapter" text="%n&#160;%t"/>
				<l:template name="section" text="%n&#160;%t"/>
				<l:template name="appendix" text="Annex&#160;%n&#160;%t"/>
				<l:template name="glossdiv" text="%n&#160;%t"/>
				<l:template name="bibliodiv" text="%n&#160;%t"/>
			</l:context>

			<!-- do not emit label or delimiter - this would be inappropriately called and label not included unless we customize the object.title.template mode templates in common/gentext.xsl to check for label value as well as autonumber -->
			<l:context name="title-unnumbered">
				<l:template name="chapter" text="%t"/>
				<l:template name="section" text="%t"/>
				<l:template name="appendix" text="%t"/>
				<l:template name="glossdiv" text="%t"/>
				<l:template name="bibliodiv" text="%t"/>
			</l:context>

			<l:context name="xref">
				<l:template name="chapter" text="Section&#160;%n, &#8220;%t&#8221;"/>
				<l:template name="appendix" text="Annex&#160;%n, &#8220;%t&#8221;"/>
				<l:template name="section" text="Section&#160;%n, &#8220;%t&#8221;"/>
			</l:context>
		</l:l10n>
	</l:i18n>

<!-- make all object.title.template mode templates in common/gentext.xsl check for label value as well as autonumber to select title-numbered rather than title-unnumbered -->

<xsl:template match="d:chapter" mode="object.title.template">
  <!--<xsl:message>gentext.xsl: d:chapter mode="object.title.template" label = "<xsl:value-of select="@label"/>"</xsl:message>-->
  <xsl:choose>
    <xsl:when test="@label != '' or string($chapter.autolabel) != 0">
  <!--<xsl:message>gentext.xsl: d:chapter mode="object.title.template" calling title-numbered</xsl:message>-->
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-numbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
  <!--<xsl:message>gentext.xsl: d:chapter mode="object.title.template" calling title-unnumbered</xsl:message>-->
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-unnumbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:appendix" mode="object.title.template">
  <xsl:choose>
    <xsl:when test="@label != '' or string($chapter.autolabel) != 0">
  <!--<xsl:message>gentext.xsl: d:appendix mode="object.title.template" calling title-numbered</xsl:message>-->
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-numbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
  <!--<xsl:message>gentext.xsl: d:appendix mode="object.title.template" calling title-unnumbered</xsl:message>-->
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-unnumbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- don't actually use part within our documents, but here for completeness -->
<!--<xsl:template match="d:part" mode="object.title.template">
  <xsl:choose>
    <xsl:when test="@label != '' or string($part.autolabel) != 0">
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-numbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-unnumbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>-->

<xsl:template match="d:section|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5|d:simplesect
                     |d:bridgehead|d:topic"
              mode="object.title.template">
  <xsl:variable name="is.numbered">
    <xsl:call-template name="label.this.section"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="@label != '' or $is.numbered != 0">
  <!--<xsl:message>gentext.xsl: d:section et al mode="object.title.template" calling title-numbered</xsl:message>-->
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-numbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
  <!--<xsl:message>gentext.xsl: d:section et al mode="object.title.template" calling title-unnumbered</xsl:message>-->
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-unnumbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
