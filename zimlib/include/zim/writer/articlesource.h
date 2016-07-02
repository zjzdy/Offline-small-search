/*
 * Copyright (C) 2009 Tommi Maekitalo
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * is provided AS IS, WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, and
 * NON-INFRINGEMENT.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
 *
 */

#ifndef ZIM_WRITER_ARTICLESOURCE_H
#define ZIM_WRITER_ARTICLESOURCE_H

#include <stdexcept>
#include <zim/blob.h>
#include <zim/zim.h>
#include <zim/fileheader.h>
#include <string>

namespace zim
{
  namespace writer
  {
    class ArticleSource;
    class Article
    {
      public:
        virtual std::string getAid() const = 0;
        virtual char getNamespace() const = 0;
        virtual std::string getUrl() const = 0;
        virtual std::string getTitle() const = 0;
        virtual size_type getVersion() const;
        virtual bool isRedirect() const;
        virtual bool isLinktarget() const;
        virtual bool isDeleted() const;
        virtual std::string getMimeType() const = 0;
        virtual bool shouldCompress() const;
        virtual std::string getRedirectAid() const;
        virtual std::string getParameter() const;
        /* Idealy this method should be pure virtual,
         * but for compatibility reasons, provide a default implementation
         * using the old ArticleSourc::getData.
         */
        virtual Blob getData() const;

        // returns the next category id, to which the article is assigned to
        virtual std::string getNextCategory();

      /************************************************************************/
      /* For API compatibility.
       * The default Article::getData call ArticleSource::getData.
       * So store the source of article in article to let default API compatible
       * function do its job.
       * This should be removed once every users switch to new API.
       */
      private:
        mutable ArticleSource*  __source;
        friend class ZimCreator;
      /************************************************************************/
    };

    class Category
    {
      public:
        virtual Blob getData() = 0;
        virtual std::string getUrl() const = 0;
        virtual std::string getTitle() const = 0;
    };

    class ArticleSource
    {
      public:
        virtual void setFilename(const std::string& fname) { }
        virtual const Article* getNextArticle() = 0;
        virtual Uuid getUuid();
        virtual std::string getMainPage();
        virtual std::string getLayoutPage();

        // After fetching the articles and for each article the category ids
        // using Article::getNextCategory, the writer has a list of category
        // ids. Using this list, the writer fetches the category data using
        // this method.
        virtual Category* getCategory(const std::string& cid);

        /**********************************************************************/
        /* For API compatibility.
         * The default Article::getData call ArticleSource::getData.
         * So keep the getData. Do not set it pure virtual cause we want new
         * code to not use it.
         * This should be removed once every users switch to new API.
         */
        virtual Blob getData(const std::string& aid);

        /**********************************************************************/
    };

  }
}

#endif // ZIM_WRITER_ARTICLESOURCE_H
