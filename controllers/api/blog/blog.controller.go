package blog

import (
	"github.com/dgrijalva/jwt-go"
	"github.com/labstack/echo/v4"
	"github.com/triaton/forum-backend-echo/common"
	"github.com/triaton/forum-backend-echo/database"
	"github.com/triaton/forum-backend-echo/models"
	"net/http"
)

type (
	Controller struct {
	}

	AddBlogRequest struct {
		Title   string `json:"title" validate:"required"`
		Content string `json:"content" validate:"required"`
	}
)

func (controller Controller) Routes() []common.Route {
	return []common.Route{
		{
			Method:     echo.POST,
			Path:       "/blogs",
			Handler:    controller.AddBlog,
			Middleware: []echo.MiddlewareFunc{common.JwtMiddleWare()},
		},
		{
			Method:  echo.GET,
			Path:    "/blogs",
			Handler: controller.GetBlogs,
		},
		{
			Method:  echo.GET,
			Path:    "/blogs/:blogId",
			Handler: controller.GetBlog,
		},
	}
}

func (controller Controller) AddBlog(ctx echo.Context) error {
	params := new(AddBlogRequest)
	if err := ctx.Bind(params); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err)
	}
	if err := ctx.Validate(params); err != nil {
		return ctx.JSON(http.StatusBadRequest, err)
	}
	user := ctx.Get("user").(*jwt.Token)
	claims := user.Claims.(*common.JwtCustomClaims)
	db := database.GetInstance()
	var blog models.Blog
	blog.Content = params.Content
	blog.Title = params.Title
	blog.UserID = claims.Id
	db.Create(&blog)
	return ctx.JSON(http.StatusOK, blog)
}

func (controller Controller) GetBlogs(ctx echo.Context) error {
	db := database.GetInstance()
	var blogs []models.Blog
	db.Find(&blogs)
	return ctx.JSON(http.StatusOK, blogs)
}

func (controller Controller) GetBlog(ctx echo.Context) error {
	blogId := ctx.Param("blogId")
	db := database.GetInstance()
	var blog models.Blog
	err := db.First(&blog, "id = ?", blogId).Error
	if err != nil {
		return echo.NewHTTPError(http.StatusNotFound, "Blog not found")
	}
	return ctx.JSON(http.StatusOK, blog)
}