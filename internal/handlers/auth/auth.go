package auth

import (
	"time"

	"github.com/aptdeco/hypokorisma/internal/util"
	jwt "github.com/dgrijalva/jwt-go"
	"github.com/pkg/errors"
)

// Adapter will be implemented by each oAuth provider
type Adapter interface {
	GetRedirectURL(state string) string
	GetUserData(state, code string) (*user, error)
	GetOAuthProviderName() string
}

type user struct {
	ID, Name, Picture string
}

// JWTClaims are the data and general information which is stored in the JWT
type JWTClaims struct {
	jwt.StandardClaims
	OAuthProvider string
	OAuthID       string
	OAuthName     string
	OAuthPicture  string
}

// AdapterWrapper wraps an normal oAuth Adapter with some generic functions
// to be implemented directly by the gin router
type AdapterWrapper struct{ Adapter }

func (a *AdapterWrapper) newJWT(user *user, provider string) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, JWTClaims{
		jwt.StandardClaims{
			ExpiresAt: time.Now().Add(time.Hour * 24 * 365).Unix(),
		},
		provider,
		user.ID,
		user.Name,
		user.Picture,
	})
	tokenString, err := token.SignedString(util.GetPrivateKey())
	if err != nil {
		return "", errors.Wrap(err, "could not sign token")
	}
	return tokenString, nil
}
