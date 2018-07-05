<?xml version = "1.0" encoding = "UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eb="http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/core/200704/">

  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  <xsl:param name="timestamp" select="'1971-01-01T00:00:00Z'"/>
  <xsl:param name="messageId" select="'00000000-0000-0000-000000000000'"/>
  <xsl:param name="conversationId" select="'00000000-0000-0000-000000000000'"/>

  <!--Identity template, 
      provides default behavior that copies all content into the output -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="//eb:Timestamp">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <!--Do something special for Node766, like add a certain string-->
      <xsl:value-of select="$timestamp"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="//eb:MessageId">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <!--Do something special for Node766, like add a certain string-->
      <xsl:value-of select="$messageId"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="//eb:ConversationId">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <!--Do something special for Node766, like add a certain string-->
      <xsl:value-of select="$conversationId"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
