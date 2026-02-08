--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}

import Data.List (intercalate)
{- etc -}
import qualified Data.Map as Map
import Data.Monoid (mappend)
import Hakyll
import Skylighting (Color (..), Style (..), TokenStyle (..), defStyle)
import Skylighting.Styles (breezeDark, kate, pygments)
import Skylighting.Types
import Text.Pandoc.Highlighting (styleToCss)

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
  match "images/*" $ do
    route idRoute
    compile copyFileCompiler

  -- Stylesheet for supporting syntax highlighting.
  -- This will import the actual stylesheet according to the preferred color scheme.
  create ["css/syntax.css"] $ do
    route idRoute
    compile $
      makeItem $
        intercalate
          "\n"
          [ "@import \"syntax-light.css\" (prefers-color-scheme: light);",
            "@import \"syntax-dark.css\" (prefers-color-scheme: dark);",
            ""
          ]

  -- Syntax highlighting in light mode.
  create ["css/syntax-light.css"] $ do
    route idRoute
    compile $ makeItem $ styleToCss carboniteLight

  -- Syntax highlighting in dark mode.
  create ["css/syntax-dark.css"] $ do
    route idRoute
    compile $ makeItem $ styleToCss carboniteDark

  match "css/*" $ do
    route idRoute
    compile compressCssCompiler

  match "posts/*" $ do
    route $ setExtension "html"
    compile $
      pandocCompiler
        >>= saveSnapshot "content"
        >>= loadAndApplyTemplate "templates/post.html" postCtx
        >>= loadAndApplyTemplate "templates/default.html" (postCtx <> openGraphField "opengraph" postCtx)
        >>= relativizeUrls

  create ["atom.xml"] $ do
    route idRoute
    compile $ do
      let feedCtx =
            postCtx
              `mappend` teaserField "description" "content"

      posts <- fmap (take 10) . recentFirst =<< loadAll "posts/*"
      renderAtom myFeedConfiguration feedCtx posts

  create ["blog.html"] $ do
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAll "posts/*"
      let archiveCtx =
            listField "posts" postCtx (return posts)
              `mappend` constField "title" "Blog"
              `mappend` defaultCtx

      makeItem ""
        >>= loadAndApplyTemplate "templates/blog.html" archiveCtx
        >>= loadAndApplyTemplate "templates/default.html" archiveCtx
        >>= relativizeUrls

  match "index.html" $ do
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAll "posts/*"
      let indexCtx =
            listField "posts" postCtx (return posts)
              `mappend` defaultCtx

      getResourceBody
        >>= applyAsTemplate indexCtx
        >>= loadAndApplyTemplate "templates/default.html" indexCtx
        >>= relativizeUrls

  match "templates/*" $ compile templateBodyCompiler

--------------------------------------------------------------------------------

defaultCtx :: Hakyll.Context String
defaultCtx =
  activeClassField
    <> defaultContext
    <> constField "root" "https://okienko.day"

postCtx :: Hakyll.Context String
postCtx =
  dateField "date" "%B %e, %Y"
    `mappend` teaserField "teaser" "content"
    `mappend` defaultCtx

activeClassField :: Hakyll.Context String
activeClassField = functionField "active" $ \args item -> do
  route <- getRoute (itemIdentifier item)
  return $ case (args, route) of
    ([path], Just r) | ("/" ++ r) == path || r == path -> "data-active=\"true\""
    _ -> ""

myFeedConfiguration :: FeedConfiguration
myFeedConfiguration =
  FeedConfiguration
    { feedTitle = "Okienko - Hubert Małkowski's blog",
      feedDescription = "",
      feedAuthorName = "Hubert Małkowski",
      feedAuthorEmail = "hubert.malkowski@hey.com",
      feedRoot = "https://okienko.day"
    }

--------------------------------------------------------------------------------

-- | Carbonite dark theme based on Carbon Design System colors.
carboniteDark :: Style
carboniteDark =
  Style
    { tokenStyles =
        Map.fromList
          [ (KeywordTok, defStyle {tokenColor = Just (RGB 190 149 255)}), -- purple #be95ff
            (DataTypeTok, defStyle {tokenColor = Just (RGB 255 126 182)}), -- pinkish #ff7eb6
            (DecValTok, defStyle {tokenColor = Just (RGB 61 219 217)}), -- cyan #3ddbd9
            (BaseNTok, defStyle {tokenColor = Just (RGB 61 219 217)}), -- cyan #3ddbd9
            (FloatTok, defStyle {tokenColor = Just (RGB 61 219 217)}), -- cyan #3ddbd9
            (ConstantTok, defStyle {tokenColor = Just (RGB 61 219 217)}), -- cyan #3ddbd9
            (CharTok, defStyle {tokenColor = Just (RGB 255 131 43)}), -- orange #ff832b
            (SpecialCharTok, defStyle {tokenColor = Just (RGB 61 219 217)}), -- cyan #3ddbd9
            (StringTok, defStyle {tokenColor = Just (RGB 66 190 101)}), -- green #42be65
            (VerbatimStringTok, defStyle {tokenColor = Just (RGB 66 190 101)}), -- green #42be65
            (SpecialStringTok, defStyle {tokenColor = Just (RGB 66 190 101)}), -- green #42be65
            (ImportTok, defStyle {tokenColor = Just (RGB 255 126 182)}), -- pinkish #ff7eb6
            (CommentTok, defStyle {tokenColor = Just (RGB 111 111 111), tokenItalic = True}), -- text_tertiary #6f6f6f
            (DocumentationTok, defStyle {tokenColor = Just (RGB 111 111 111), tokenItalic = True}),
            (AnnotationTok, defStyle {tokenColor = Just (RGB 51 177 255)}), -- blue #33b1ff
            (CommentVarTok, defStyle {tokenColor = Just (RGB 111 111 111), tokenItalic = True}),
            (OtherTok, defStyle {tokenColor = Just (RGB 244 244 244)}), -- text #f4f4f4
            (FunctionTok, defStyle {tokenColor = Just (RGB 51 177 255), tokenBold = True}), -- blue #33b1ff
            (VariableTok, defStyle {tokenColor = Just (RGB 244 244 244)}), -- brightish_whitish #f4f4f4
            (ControlFlowTok, defStyle {tokenColor = Just (RGB 255 126 182)}), -- pinkish #ff7eb6
            (OperatorTok, defStyle {tokenColor = Just (RGB 255 126 182)}), -- pinkish #ff7eb6
            (BuiltInTok, defStyle {tokenColor = Just (RGB 51 177 255)}), -- blue #33b1ff
            (ExtensionTok, defStyle {tokenColor = Just (RGB 51 177 255)}), -- blue #33b1ff
            (PreprocessorTok, defStyle {tokenColor = Just (RGB 255 126 182)}), -- pinkish #ff7eb6
            (AttributeTok, defStyle {tokenColor = Just (RGB 61 219 217)}), -- cyan #3ddbd9
            (RegionMarkerTok, defStyle {tokenColor = Just (RGB 51 177 255), tokenBackground = Just (RGB 48 79 141)}), -- blue, highlight_blue
            (InformationTok, defStyle {tokenColor = Just (RGB 255 131 43)}), -- orange #ff832b
            (WarningTok, defStyle {tokenColor = Just (RGB 255 131 43)}), -- orange #ff832b
            (AlertTok, defStyle {tokenColor = Just (RGB 255 131 137), tokenBold = True}), -- red #ff8389
            (ErrorTok, defStyle {tokenColor = Just (RGB 255 131 137), tokenUnderline = True}), -- red #ff8389
            (NormalTok, defStyle {tokenColor = Just (RGB 244 244 244)}) -- text #f4f4f4
          ],
      defaultColor = Just (RGB 244 244 244), -- text #f4f4f4
      backgroundColor = Just (RGB 13 13 13), -- layer1 #0D0D0D
      lineNumberColor = Just (RGB 111 111 111), -- text_tertiary #6f6f6f
      lineNumberBackgroundColor = Just (RGB 13 13 13) -- layer1 #0D0D0D
    }

-- | Carbonite light theme based on Carbon Design System colors.
carboniteLight :: Style
carboniteLight =
  Style
    { tokenStyles =
        Map.fromList
          [ (KeywordTok, defStyle {tokenColor = Just (RGB 138 63 252)}), -- purple #8a3ffc
            (DataTypeTok, defStyle {tokenColor = Just (RGB 238 83 150)}), -- pinkish #ee5396
            (DecValTok, defStyle {tokenColor = Just (RGB 51 177 255)}), -- cyan #33b1ff
            (BaseNTok, defStyle {tokenColor = Just (RGB 51 177 255)}), -- cyan #33b1ff
            (FloatTok, defStyle {tokenColor = Just (RGB 51 177 255)}), -- cyan #33b1ff
            (ConstantTok, defStyle {tokenColor = Just (RGB 51 177 255)}), -- cyan #33b1ff
            (CharTok, defStyle {tokenColor = Just (RGB 255 131 43)}), -- orange #ff832b
            (SpecialCharTok, defStyle {tokenColor = Just (RGB 51 177 255)}), -- cyan #33b1ff
            (StringTok, defStyle {tokenColor = Just (RGB 36 161 72)}), -- green #24a148
            (VerbatimStringTok, defStyle {tokenColor = Just (RGB 36 161 72)}), -- green #24a148
            (SpecialStringTok, defStyle {tokenColor = Just (RGB 36 161 72)}), -- green #24a148
            (ImportTok, defStyle {tokenColor = Just (RGB 238 83 150)}), -- pinkish #ee5396
            (CommentTok, defStyle {tokenColor = Just (RGB 168 168 168), tokenItalic = True}), -- text_tertiary #a8a8a8
            (DocumentationTok, defStyle {tokenColor = Just (RGB 168 168 168), tokenItalic = True}),
            (AnnotationTok, defStyle {tokenColor = Just (RGB 15 98 254)}), -- blue #0f62fe
            (CommentVarTok, defStyle {tokenColor = Just (RGB 168 168 168), tokenItalic = True}),
            (OtherTok, defStyle {tokenColor = Just (RGB 22 22 22)}), -- text #161616
            (FunctionTok, defStyle {tokenColor = Just (RGB 15 98 254), tokenBold = True}), -- blue #0f62fe
            (VariableTok, defStyle {tokenColor = Just (RGB 22 22 22)}), -- brightish_whitish #161616
            (ControlFlowTok, defStyle {tokenColor = Just (RGB 238 83 150)}), -- pinkish #ee5396
            (OperatorTok, defStyle {tokenColor = Just (RGB 238 83 150)}), -- pinkish #ee5396
            (BuiltInTok, defStyle {tokenColor = Just (RGB 15 98 254)}), -- blue #0f62fe
            (ExtensionTok, defStyle {tokenColor = Just (RGB 15 98 254)}), -- blue #0f62fe
            (PreprocessorTok, defStyle {tokenColor = Just (RGB 238 83 150)}), -- pinkish #ee5396
            (AttributeTok, defStyle {tokenColor = Just (RGB 51 177 255)}), -- cyan #33b1ff
            (RegionMarkerTok, defStyle {tokenColor = Just (RGB 15 98 254), tokenBackground = Just (RGB 230 232 245)}), -- blue, highlight_blue
            (InformationTok, defStyle {tokenColor = Just (RGB 255 131 43)}), -- orange #ff832b
            (WarningTok, defStyle {tokenColor = Just (RGB 255 131 43)}), -- orange #ff832b
            (AlertTok, defStyle {tokenColor = Just (RGB 218 30 40), tokenBold = True}), -- red #da1e28
            (ErrorTok, defStyle {tokenColor = Just (RGB 218 30 40), tokenUnderline = True}), -- red #da1e28
            (NormalTok, defStyle {tokenColor = Just (RGB 22 22 22)}) -- text #161616
          ],
      defaultColor = Just (RGB 22 22 22), -- text #161616
      backgroundColor = Just (RGB 255 255 255), -- layer1 #ffffff
      lineNumberColor = Just (RGB 168 168 168), -- text_tertiary #a8a8a8
      lineNumberBackgroundColor = Just (RGB 255 255 255) -- layer1 #ffffff
    }
