<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:docbook="http://docbook.org/ns/docbook"
	xmlns="http://docbook.org/ns/docbook"
  	version="1.0">

<xsl:output method="text" encoding="utf-8"/>

<xsl:variable name="quote">"</xsl:variable>

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

<xsl:template name="titleCaseWord">
	<xsl:param name="s"/>

	<xsl:value-of select="translate(substring($s,1,1),$lowercase,$uppercase)"/>
	<xsl:value-of select="substring($s,2,string-length($s)-1)"/>
</xsl:template>

<xsl:template name="titleCaseRemovingSpaces">
	<xsl:param name="s"/>

	<xsl:variable name="rest"><xsl:value-of select="substring-after($s,' ')"/></xsl:variable>
	<xsl:choose>
        <xsl:when test="string-length($rest) > 0">
			<xsl:call-template name="titleCaseWord">
                <xsl:with-param name="s" select="substring-before($s,' ')"/>
            </xsl:call-template>
			<xsl:call-template name="titleCaseRemovingSpaces">
                <xsl:with-param name="s" select="$rest"/>
            </xsl:call-template>
		</xsl:when>
        <xsl:otherwise>
			<xsl:call-template name="titleCaseWord">
                <xsl:with-param name="s" select="$s"/>
            </xsl:call-template>
        </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="processModuleRow">
	<xsl:param name="columnoffset"/>

		<xsl:variable name="module"><xsl:value-of select="translate(normalize-space(docbook:td[number($columnoffset)]/docbook:para),' ','')"/></xsl:variable>

		<xsl:variable name="usageFullText"><xsl:value-of select="normalize-space(docbook:td[number($columnoffset)+2]/docbook:para)"/></xsl:variable>
		<xsl:variable name="usage"><xsl:value-of select="substring($usageFullText,1,1)"/></xsl:variable>

		<xsl:text>&#x9;</xsl:text>
		<xsl:text>&#x9;</xsl:text>
		<xsl:text>Module=</xsl:text>
		<xsl:value-of select="$quote"/>
		<xsl:value-of select="$module"/>
		<xsl:value-of select="$quote"/>

		<xsl:text>&#x9;</xsl:text>
		<xsl:text>Usage=</xsl:text>
		<xsl:value-of select="$quote"/>
		<xsl:value-of select="$usage"/>
		<xsl:value-of select="$quote"/>
		
		<xsl:if test="$usage = 'C'">
			<!--<xsl:variable name="condition"><xsl:value-of select="translate(substring($usageFullText,2,string-length($usageFullText)-1),'-','')"/></xsl:variable>-->

			<xsl:variable name="condition">
				<xsl:call-template name="titleCaseRemovingSpaces">
					<xsl:with-param name="s" select="normalize-space(translate(substring($usageFullText,2,string-length($usageFullText)-1),'-',''))"/>
				</xsl:call-template>
			</xsl:variable>

			<xsl:text>&#x9;</xsl:text>
			<xsl:text>Condition=</xsl:text>
			<xsl:value-of select="$quote"/>
			<xsl:value-of select="$condition"/>
			<xsl:value-of select="$quote"/>
		</xsl:if>

		<xsl:value-of select="$newline"/>

</xsl:template>

<xsl:template match="docbook:table">
	<xsl:if test="contains(docbook:caption,'IOD Modules')
			  and docbook:thead/docbook:tr/docbook:th[1]/docbook:para = 'IE'
			  and docbook:thead/docbook:tr/docbook:th[2]/docbook:para = 'Module'
			  and docbook:thead/docbook:tr/docbook:th[3]/docbook:para = 'Reference'
			  and docbook:thead/docbook:tr/docbook:th[4]/docbook:para = 'Usage'">
		<xsl:variable name="iod"><xsl:value-of select="substring-before(translate(normalize-space(docbook:caption),' -',''),'IODModules')"/></xsl:variable>
		<xsl:text>CompositeIOD=</xsl:text>
		<xsl:value-of select="$quote"/>
		<xsl:value-of select="$iod"/>
		<xsl:value-of select="$quote"/>
		<xsl:text> Condition=</xsl:text>
		<xsl:value-of select="$quote"/>
		<xsl:value-of select="$iod"/>
		<xsl:text>Instance</xsl:text>
		<xsl:value-of select="$quote"/>
		<xsl:value-of select="$newline"/>

		<!-- <xsl:apply-templates/> -->
		
		<xsl:for-each select="docbook:tbody/docbook:tr">
			<xsl:choose>
				<xsl:when test="count(docbook:td) = 4">
					<xsl:if test="count(preceding-sibling::docbook:tr) > 0">
						<xsl:text>&#x9;</xsl:text>
						<xsl:text>InformationEntityEnd</xsl:text>
						<xsl:value-of select="$newline"/>
					</xsl:if>
					<xsl:variable name="ie"><xsl:value-of select="translate(normalize-space(docbook:td[1]/docbook:para),' ','')"/></xsl:variable>
					<xsl:text>&#x9;</xsl:text>
					<xsl:text>InformationEntity=</xsl:text>
					<xsl:value-of select="$quote"/>
					<xsl:value-of select="$ie"/>
					<xsl:value-of select="$quote"/>
					<xsl:value-of select="$newline"/>
					<xsl:call-template name="processModuleRow">
						<xsl:with-param name="columnoffset" select="'2'"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="count(docbook:td) = 3">
					<xsl:call-template name="processModuleRow">
						<xsl:with-param name="columnoffset" select="'1'"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		
		<xsl:text>&#x9;</xsl:text>
		<xsl:text>InformationEntityEnd</xsl:text>
		<xsl:value-of select="$newline"/>

		<xsl:text>CompositeIODEnd</xsl:text>
		<xsl:value-of select="$newline"/>
	</xsl:if>
</xsl:template>

<xsl:template match="@*|node()">
	<xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
