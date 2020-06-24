analisis_pca <- function (x, ...) UseMethod("analisis_pca")
analisis_pca.default <-
    function(x, retx = TRUE, center = TRUE, scale. = FALSE, tol = NULL,
             rank. = NULL, ...)
{
    chkDots(...)
    x <- as.matrix(x)
    x <- scale(x, center = center, scale = scale.)
    cen <- attr(x, "scaled:center")
    sc <- attr(x, "scaled:scale")
    if(any(sc == 0))
        stop("cannot rescale a constant/zero column to unit variance")
    n <- nrow(x)
    p <- ncol(x)
    k <- if(!is.null(rank.)) {
             stopifnot(length(rank.) == 1, is.finite(rank.), as.integer(rank.) > 0)
             min(as.integer(rank.), n, p)
             ## Note that La.svd() *still* needs a (n x p) and a (p x p) auxiliary
         } else
             min(n, p)
    s <- svd(x, nu = 0, nv = k)
    j <- seq_len(k)
    s$d <- s$d / sqrt(max(1, n - 1))
    if (!is.null(tol)) {
        ## we get rank at least one even for a 0 matrix.
        rank <- sum(s$d > (s$d[1L]*tol))
        if (rank < k) {
            j <- seq_len(k <- rank)
            s$v <- s$v[,j , drop = FALSE]
        }
    }
    dimnames(s$v) <- list(colnames(x), paste0("PC", j))
    r <- list(sdev = s$d, rotation = s$v,
              center = if(is.null(cen)) FALSE else cen,
              scale = if(is.null(sc)) FALSE else sc)
    if (retx) r$x <- x %*% s$v
    class(r) <- "analisis_pca"
    r
}

analisis_pca.formula <- function (formula, data = NULL, subset, na.action, ...)
{
    mt <- terms(formula, data = data)
    if (attr(mt, "response") > 0L)
        stop("response not allowed in formula")
    cl <- match.call()
    mf <- match.call(expand.dots = FALSE)
    mf$... <- NULL
    ## need stats:: for non-standard evaluation
    mf[[1L]] <- quote(stats::model.frame)
    mf <- eval.parent(mf)
    ## this is not a `standard' model-fitting function,
    ## so no need to consider contrasts or levels
    if (.check_vars_numeric(mf))
        stop("PCA applies only to numerical variables")
    na.act <- attr(mf, "na.action")
    mt <- attr(mf, "terms")
    attr(mt, "intercept") <- 0L
    x <- model.matrix(mt, mf)
    res <- analisis_pca.default(x, ...)
    ## fix up call to refer to the generic, but leave arg name as `formula'
    cl[[1L]] <- as.name("analisis_pca")
    res$call <- cl
    if (!is.null(na.act)) {
        res$na.action <- na.act
        if (!is.null(sc <- res$x))
            res$x <- napredict(na.act, sc)
    }
    res
}


print.analisis_pca <- function(x, print.x = FALSE, ...) {
    cat("Standart Deviation:\n")
    print(x$sdev, ...)
    cat("Variance / EigenValue:\n")
    print((x$sdev)^2, ...)
    d <- dim(x$rotation)
    cat(sprintf("\nRotation (n x k) = (%d x %d):\n", d[1], d[2]))
    print(x$rotation, ...)
    if (print.x && length(x$x)) {
        cat("\nRotated variables:\n")
        print(x$x, ...)
    }
    invisible(x)
}

