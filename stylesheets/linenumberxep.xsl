<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xep="http://www.renderx.com/XEP/xep"
    version="2.0">
    <!--true() for Accessible documents, 
        false() if you are not producing Accessible documents -->
    <xsl:param name="access" select="true()"/>
    <xsl:variable name="xpos" select="10000"/>
    <xsl:variable name="tolerance" select="1000"/>
    <xsl:variable name="numcolor" select=".2"/>
    <xsl:variable name="fsize" select="9000"/>

    <xsl:template match="xep:text">
        <xsl:variable name="ypos" select="@y"/>
        <xsl:variable name="test1" select="preceding-sibling::xep:text[not(@y=$ypos)]"/>
        <xsl:variable name="test2" select="distinct-values($test1/@y)"/>
        <xsl:variable name="linenum" select="count($test2) + 1"/>
        <xsl:variable name="numbering" select="string(preceding-sibling::xep:pinpoint[1]/@value)"/>
        <!-- if the "Y" is unique, put down a linenumber -->
        <xsl:if test="not(preceding-sibling::xep:text/@y = $ypos) and ($numbering='' or $numbering='numbered')">
            <xep:gray-color gray="{$numcolor}"/>
            <xep:font family="ArialUnicodeMS" weight="400" style="normal" variant="normal" size="{$fsize}"/>
            <xep:text x="{$xpos}" y="{$ypos}" value="{$linenum}" width="7000">
                <!-- Add accessibility attribute, mark as Artifact -->
                <xsl:if test="$access">
                    <xsl:attribute name="xpath">
                        <xsl:value-of select="@xpath"/>
                    </xsl:attribute>
                    <xsl:attribute name="pdf-structure-tag">
                        <xsl:text>Artifact</xsl:text>
                    </xsl:attribute>
                </xsl:if>
            </xep:text>
            <xsl:copy-of select="preceding-sibling::*[contains(name(), 'font')]"/>
            <xsl:copy-of select="preceding-sibling::*[contains(name(), 'color')]"/>
            
        </xsl:if>
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
